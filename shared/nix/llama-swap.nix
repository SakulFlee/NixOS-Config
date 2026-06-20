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
        "unsloth/Qwen3.5-9B-MTP-GGUF" = {
          cmd = ''
            ${llama-server} \
              --port ''${PORT} \
              -hf unsloth/Qwen3.5-9B-MTP-GGUF \
              -c 8192 \
              -fit on
          '';
        };
        "unsloth/gemma-4-E4B-it-qat-GGUF:UD-Q4_K_XL (Laptop config)" = {
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
        "unsloth/gemma-4-E4B-it-qat-GGUF:UD-Q4_K_XL (full + rerank)" = {
          cmd = ''
            # Note: --fit on usually works, but is bugged here because of MTP
            ${llama-server} \
              --port ''${PORT}
              -hf unsloth/gemma-4-E4B-it-qat-GGUF:UD-Q4_K_XL \
              -c 8192 \
              --rerank \
              -fit off \
              --spec-type draft-mtp \
              --spec-draft-n-max 2 \
              -ngl 99 
          '';
        };

        "unsloth/gemma-4-E4B-it-qat-GGUF:UD-Q4_K_XL (full)" = {
          cmd = ''
            # Note: --fit on usually works, but is bugged here because of MTP
            ${llama-server} \
              --port ''${PORT}
              -hf unsloth/gemma-4-E4B-it-qat-GGUF:UD-Q4_K_XL \
              -c 8192 \
              -fit off \
              --spec-type draft-mtp \
              --spec-draft-n-max 2 \
              -ngl 99 
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
        "yuxinlu1/gemma-4-12B-agentic-fable5-composer2.5-v2-3.5x-tau2-GGUF" = {
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
