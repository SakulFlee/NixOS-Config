{ unstable, ... }:
{
  services.ollama = {
    enable = true;
    package = unstable.ollama;
  };

  # WebUI
  services.nextjs-ollama-llm-ui = {
    enable = true;
    port = 30003;
  };
}
