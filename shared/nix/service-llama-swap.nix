{ configs, pkgs, lib, ... }: 
let
  llama-cpp = pkgs.llama-cpp.override { vulkanSupport = true; };
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
            ${llama-server} --port ''${PORT} -hf unsloth/gemma-4-E4B-it-qat-GGUF
          '';
        };
      };
    };
  };

  # Fixes the /proc/meminfo error
  systemd.services.llama-swap.serviceConfig = {
    ProcSubset = lib.mkForce "all";
  };
}
