{ unstable, ... }:
{
  services.ollama = {
    enable = true;
    package = unstable.ollama;
  };
}
