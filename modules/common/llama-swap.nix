{
  pkgs,
  inputs,
  configs,
  lib,
  ...
}:let
  llama-cpp = inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    useVulkan = true;
  };
  llama-server = lib.getExe' llama-cpp "llama-server";

  # Build llama-server from an arbitrary llama.cpp revision with the Vulkan
  # backend (matching the default build above) and the embedded Web UI.
  mkLlamaServer =
    {
      name,
      src,
      patches ? [ ],
      cmakeFlags ? [ ],
    }:
    let
      # npm deps for tools/ui — package-lock.json is identical across the
      # upstream rev, the PrismML fork, and the limite-patched rev.
      npmDeps = pkgs.fetchNpmDeps {
        name = "${name}-npm-deps";
        inherit src patches;
        preBuild = "pushd tools/ui";
        hash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";
      };
    in
    pkgs.stdenv.mkDerivation {
      inherit name src patches;

      nativeBuildInputs = [
        pkgs.cmake
        pkgs.pkg-config
        pkgs.shaderc # glslc, compiles the Vulkan shaders
        pkgs.nodejs
        pkgs.npmHooks.npmConfigHook
      ];

      buildInputs = [
        pkgs.openssl
        pkgs.spirv-headers
        pkgs.vulkan-headers
        pkgs.vulkan-loader
      ];

      npmRoot = "tools/ui";
      inherit npmDeps;

      # Build the Web UI from source so llama-server embeds it (needed for
      # the "Open model server" button in the llama-swap UI).
      preConfigure = ''
        pushd tools/ui
        npm run build
        popd
      '';

      cmakeFlags = [
        "-DBUILD_SHARED_LIBS=OFF"
        "-DGGML_VULKAN=ON"
        "-DLLAMA_BUILD_APP=OFF"
        "-DLLAMA_BUILD_EXAMPLES=OFF"
        "-DLLAMA_BUILD_SERVER=ON"
        "-DLLAMA_BUILD_TESTS=OFF"
        "-DLLAMA_BUILD_UI=ON"
        "-DLLAMA_TESTS_INSTALL=OFF"
        "-DLLAMA_TOOLS_INSTALL=OFF"
        # Assets are already built by preConfigure; skip the HF-bucket fallback.
        "-DLLAMA_USE_PREBUILT_UI=OFF"
      ]
      ++ cmakeFlags;

      buildPhase = ''
        runHook preBuild
        cmake --build . --parallel "$NIX_BUILD_CORES" --target llama-server
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p "$out/bin"
        cp bin/llama-server "$out/bin/"
        runHook postInstall
      '';
    };

  # PrismML-Eng fork: required for GGUFs that use fork-only features such as
  # the qwen35 architecture with PTQ1_0 ternary kernels (Ternary Bonsai 2).
  # Stock llama.cpp cannot load these models.
  bonsai-llama-server = lib.getExe' (
    mkLlamaServer {
      name = "llama-server-bonsai";
      src = pkgs.fetchFromGitHub {
        owner = "PrismML-Eng";
        repo = "llama.cpp";
        rev = "5ae2e169eac202d2f065606539c3ad6ab8b51333";
        hash = "sha256-s/78i60kIa0arNPHAN4QZqLRjmcQKoUhKIk7OasoHLM=";
      };
    }
  ) "llama-server";

  # Upstream llama.cpp plus the Tdamre "limite" runtime patch, required by the
  # limite-1b-violetto GGUFs. The patch is pinned against exactly this
  # revision (see runtime/README.md of Tdamre/limite-1b-violetto-GGUF-LiteRT).
  limite-llama-server = lib.getExe' (
    mkLlamaServer {
      name = "llama-server-limite";
      src = pkgs.fetchFromGitHub {
        owner = "ggml-org";
        repo = "llama.cpp";
        rev = "58367713a6935c0810103378144008df32e3d5db";
        hash = "sha256-XW9oFf8CQd7+zWMtvBQ5uP9iJZrulaUC5MUOX1vsCDU=";
      };
      patches = [
        (pkgs.fetchurl {
          url = "https://huggingface.co/Tdamre/limite-1b-violetto-GGUF-LiteRT/resolve/main/runtime/limite.patch";
          hash = "sha256-BibS4jyO70O+4ubjGs9XSqR1fkVW+tQvFGozFMwS9Bg=";
        })
      ];
    }
  ) "llama-server";
in
{
  services.llama-swap = {
    enable = true;
    port = 30001;
    settings = {
      # Unload models after 30 minutes of inactivity to free VRAM.
      globalTTL = 1800;

      # Large models can pull tens of GB via -hf on first start; the health
      # check countdown restarts on progress updates, but be generous anyway.
      healthCheckTimeout = 600;

      macros = {
        # Shared server preamble for every llama-server build. Note: llama-swap
        # expands macros in reverse declaration order, and Nix serializes this
        # attrset alphabetically, so macros must NOT nest earlier-sorting names
        # (e.g. a macro "a" referencing "common" would never expand). Keep
        # macros flat: server macros are just the binary path, flags live in
        # "common", and every model cmd references both explicitly.
        "common" = ''
          --host 127.0.0.1 \
            --port ''${PORT} \
            -fa on \
            -fit on \
            -c 64000
        '';
        # Stock llama.cpp from the flake input (supports --moe-cache-mib).
        "default" = "${llama-server}";
        # --moe-cache-mib hard-errors on dense models ("MoE cache requires a
        # MoE model"), so it must only be appended to MoE model cmds.
        "moe" = "--moe-cache-mib 4096";
        # PrismML-Eng fork build, for GGUFs with fork-only features (e.g. the
        # ternary PTQ1_0 kernels of Ternary Bonsai 2). No --moe-cache-mib here.
        "bonsai_llama" = "${bonsai-llama-server}";
        # Upstream llama.cpp + Tdamre limite patch, for the limite-1b-violetto
        # GGUFs. No --moe-cache-mib here.
        "limite_llama" = "${limite-llama-server}";
        "with_mtp" = "--spec-type draft-mtp";
        "with_dspark" = "--spec-type draft-dspark";
      };
      models = {
        "[unsloth] Qwen3.5 9B @UD-Q4_K_XL [MTP]" = {
          cmd = ''
            ''${default} ''${common} \
              ''${with_mtp} \
              --spec-draft-n-max 6 \
              -hf unsloth/Qwen3.5-9B-MTP-GGUF:UD-Q4_K_XL
          '';
          capabilities.context = 64000;
        };
        "[unsloth] Qwen3.5 27B @UD-Q4_K_XL [MTP]" = {
          cmd = ''
            ''${default} ''${common} \
              ''${with_mtp} \
              --spec-draft-n-max 4 \
              -hf unsloth/Qwen3.5-27B-MTP-GGUF:UD-Q4_K_XL
          '';
          capabilities.context = 64000;
        };
        "[unsloth] Qwen3.5 35B-A3B @UD-Q4_K_XL [MTP]" = {
          cmd = ''
            ''${default} ''${common} ''${moe} \
              ''${with_mtp} \
              --spec-draft-n-max 2 \
              -hf unsloth/Qwen3.5-35B-A3B-MTP-GGUF:UD-Q4_K_XL
          '';
          capabilities.context = 64000;
        };
        "[unsloth] Qwen3.6 35B-A3B @UD-Q4_K_XL [MTP]" = {
          cmd = ''
            ''${default} ''${common} ''${moe} \
              ''${with_mtp} \
              --spec-draft-n-max 2 \
              -hf unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_XL
          '';
          capabilities.context = 64000;
        };
        "[unsloth] Gemma4 26B-A4B @UD-Q4_K_XL [QAT] [MTP]" = {
          cmd = ''
            ''${default} ''${common} ''${moe} \
              ''${with_mtp} \
              --spec-draft-n-max 4 \
              -hf unsloth/gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL
          '';
          capabilities.context = 64000;
        };
        "[unsloth] Gemma4 12B @UD-Q4_K_XL [QAT] [MTP]" = {
          cmd = ''
            ''${default} ''${common} \
              ''${with_mtp} \
              -hf unsloth/gemma-4-12B-it-qat-GGUF:UD-Q4_K_XL
          '';
          capabilities.context = 64000;
        };
        "Ornith 1.5 9B @Q4_K_M" = {
          cmd = ''
            ''${default} ''${common} \
              -hf ornith-ai/Ornith-1.5-9B-GGUF:Q4_K_M
          '';
          capabilities.context = 64000;
        };
        "Ornith 1.5 35B-A3B @Q4_K_M" = {
          cmd = ''
            ''${default} ''${common} ''${moe} \
              -hf ornith-ai/Ornith-1.5-35B-A3B-GGUF:Q4_K_M
          '';
          capabilities.context = 64000;
        };
        "LiquidAI/LFM2.5-24B-A2B @Q4_K_M" = {
          cmd = ''
            ''${default} ''${common} ''${moe} \
              -hf LiquidAI/LFM2.5-24B-A2B-GGUF:Q4_K_M
          '';
          capabilities.context = 64000;
        };
        "[openbmb] MiniCPM-V 4.7 35B-A3B @Q4_K_M" = {
          cmd = ''
            ''${default} ''${common} ''${moe} \
              -hf openbmb/MiniCPM-V-4.7-35B-A3B-gguf:Q4_K_M
          '';
          capabilities.context = 64000;
        };
        "[openbmb] MiniCPM-V 4.7 1B @Q8_0" = {
          cmd = ''
            ''${default} ''${common} \
              ''${with_dspark} \
              --spec-draft-hf openbmb/MiniCPM-V-4.7-1B-DSpark-gguf:Q4_K_M \
              -hf openbmb/MiniCPM-V-4.7-1B-gguf:Q8_0
          '';
          capabilities.context = 64000;
        };
        "ConwayResearch/Underdog-Saluki-27B-1.0" = {
          cmd = ''
            ''${default} ''${common} \
              -hf ConwayResearch/Underdog-Saluki-27B-1.0
          '';
          capabilities.context = 64000;
        };
        "ggml-org/MiMo-V2.6-Distill-Qwen-9B-GGUF" = {
          cmd = ''
            ''${default} ''${common} \
              -hf ggml-org/MiMo-V2.6-Distill-Qwen-9B-GGUF
          '';
          capabilities.context = 64000;
        };
        "Ternary Bonsai 2 27B" = {
          cmd = ''
            ''${bonsai_llama} ''${common} \
              -hf prism-ml/Ternary-Bonsai-2-27B-gguf:PQ2_0
          '';
          capabilities.context = 64000;
        };
      };
    };
  };

  systemd.services.llama-swap.serviceConfig = {
    # Fixes /proc/meminfo error
    ProcSubset = lib.mkForce "all";

    # Fixes cache location error
    Environment = [ "HOME=/var/lib/llama-swap" ];
    StateDirectory = "llama-swap";

    # Fixes JIT cache compilation errors
    MemoryDenyWriteExecute = lib.mkForce false;
    ProtectControlGroups = lib.mkForce false;

    # GPU access for Vulkan (AMD ROCm, etc.)
    SupplementaryGroups = [
      "render"
      "video"
    ];
    PrivateDevices = lib.mkForce false;
  };
}
