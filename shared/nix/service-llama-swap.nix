{ pkgs, inputs, configs, lib, ... }: 
let
  llama-cpp = inputs.llama-cpp.packages.${pkgs.system}.default.override {
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
        "gemma-4-E4B-it-qat-CPU-ONLY" = {
          cmd = ''
            ${llama-server} \
              --port ''${PORT} \
              -hf unsloth/gemma-4-E4B-it-qat-GGUF:UD-Q4_K_XL \
              -c 4096 \
              -fit off \
              --spec-type draft-mtp \
              --spec-draft-n-max 2 \
              -ngl 0 \
              -t 8
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
