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
        name = "qwen3.5 9B";
        cmd = ''
          ${llama-server} --port \${PORT} -hf unsloth/Qwen3.5-9B-MTP-GGUF
        '';
      };
    };
  };
}
