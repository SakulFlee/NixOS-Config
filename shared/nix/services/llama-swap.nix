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
    port = 30001;
    settings = {
      macros = {
        "default" = ''
          ${llama-server} \
            --host 127.0.0.1 \
            --port ''${PORT} \
            -c 65536
        '';
        "with_fit" = ''
          ''${default} \
            -fit on
        '';
        "with_mtp" = ''
          ''${default} \
            --spec-type draft-mtp
        '';
        "with_mtp_and_fit" = ''
          ''${default} \
            -fit on \
            --spec-type draft-mtp
        '';
      };
      models = {
        "[unsloth] Gemma4 26B-A4B @Q4_K_XL - IT QAT MTP" = {
          cmd = ''
            ''${with_mtp_and_fit} \
              -hf unsloth/gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL \
              --spec-draft-n-max 4 \
              -fa on
          '';
        };
        "[MTP] empero-ai/Qwythos-9B-Claude-Mythos-5-1M-GGUF:Q4_K_M" = {
          cmd = ''
            ''${with_mtp_and_fit} \
              -hf empero-ai/Qwythos-9B-Claude-Mythos-5-1M-GGUF:Q4_K_M \
              -m Qwythos-9B-Claude-Mythos-5-1M-MTP-Q4_K_M.gguf
          '';
        };
        "unsloth/Qwen3.5-9B-MTP-GGUF" = {
          cmd = ''
            ''${with_mtp} \
              -hf unsloth/Qwen3.5-9B-MTP-GGUF
          '';
        };
        "unsloth/gemma-4-E4B-it-qat-GGUF:UD-Q4_K_XL (Laptop config)" = {
          cmd = ''
            ''${with_mtp} \
              -hf unsloth/gemma-4-E4B-it-qat-GGUF:UD-Q4_K_XL \
              -c 8192 \
              -ngl 35
          '';
        };
        "unsloth/gemma-4-E4B-it-qat-GGUF:UD-Q4_K_XL" = {
          cmd = ''
            ''${with_mtp_and_fit} \
              -hf unsloth/gemma-4-E4B-it-qat-GGUF:UD-Q4_K_XL
          '';
        };
        "unsloth/gemma-4-12B-it-qat-GGUF:UD-Q4_K_XL" = {
          cmd = ''
            ''${with_mtp_and_fit} \
              -hf unsloth/gemma-4-12B-it-qat-GGUF:UD-Q4_K_XL
          '';
        };
        "unsloth/gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL" = {
          cmd = ''
            ''${with_mtp_and_fit} \
              -hf unsloth/gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL
          '';
        };
        "yuxinlu1/gemma-4-12B-agentic-fable5-composer2.5-v2-3.5x-tau2-GGUF" = {
          cmd = ''
            ''${with_fit} \
              -hf yuxinlu1/gemma-4-12B-agentic-fable5-composer2.5-v2-3.5x-tau2-GGUF:Q4_K_M
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
