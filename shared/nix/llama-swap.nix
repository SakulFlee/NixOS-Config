{ pkgs, inputs, configs, lib, ... }: 
let
  llama-cpp = inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    useVulkan = true;
  };
  llama-server = lib.getExe' llama-cpp "llama-server";
in
{
  services.llama-swap = {
    enable = true;
    settings = {
      models = {
        "qwen3.5-9b-mtp" = {
          cmd = ''
            ${llama-server} --port ''${PORT} -hf unsloth/Qwen3.5-9B-MTP-GGUF
          '';
        };
        "gemma-4-e4b-it-qat" = {
          cmd = ''
            # Note: --fit on usually works, but is bugged here because of MTP
            ${llama-server} \
              --port ''${PORT}
              -hf unsloth/gemma-4-E4B-it-qat-GGUF:UD-Q4_K_XL \
              -c 8192 \
              -fit off \
              --spec-type draft-mtp \
              --spec-draft-n-max 2 \
              -ngl 35 
          '';
        };
        "yuxinlu1/gemma-4-12B-coder-fable5-composer2.5-v1:Q4_K_M" = {
          cmd = ''
            ${llama-server} \
              --port ''${PORT}
              -hf yuxinlu1/gemma-4-12B-coder-fable5-composer2.5-v1-GGUF:Q4_K_M \
              -c 8192 \
              -fit on
            '';
        };
        "yuxinlu1/gemma-4-12B-coder-fable5-composer2.5-v1:Q6_0" = {
          cmd = ''
            ${llama-server} \
              --port ''${PORT}
              -hf yuxinlu1/gemma-4-12B-coder-fable5-composer2.5-v1-GGUF:Q6_0 \
              -c 8192 \
              -fit on
            '';
        };
        "yuxinlu1/gemma-4-12B-coder-fable5-composer2.5-v1:Q8_0" = {
          cmd = ''
            ${llama-server} \
              --port ''${PORT}
              -hf yuxinlu1/gemma-4-12B-coder-fable5-composer2.5-v1-GGUF:Q8_0 \
              -c 8192 \
              -fit on
            '';
        };
        "VibeThinker-3B" = {
          cmd = ''
            ${llama-server} \
              --port ''${PORT}
              -hf prithivMLmods/VibeThinker-3B-GGUF:Q8_0 \
              -c 8192 \
              -fit on
            '';
        };
        "Gemma4_12B-Agentic-Fable5-Composer2.5-v2-3.5x-tau2" = {
          cmd = ''
            ${llama-server} \
              --port ''${PORT}
              -hf yuxinlu1/gemma-4-12B-agentic-fable5-composer2.5-v2-3.5x-tau2-GGUF:Q4_K_M \
              -c 8192 \
              -fit on
            '';
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
  };
}
