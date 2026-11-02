{ inputs, config, ... }:
let
  llamaSwapUrl = "http://127.0.0.1:30001/v1";

  llamaSwapAlias = model: {
    inherit model;
    provider = "custom";
    base_url = llamaSwapUrl;
  };
in
{
  imports = [ inputs.hermes-agent.homeManagerModules.default ];

  sops.secrets."hermes/desktop-token" = {};

  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };

  services.hermes-agent = {
    enable = true;
    backend.mode = "serve";
    backend.sessionTokenFile = config.sops.secrets."hermes/desktop-token".path;

    settings = {
      model = {
        default = "LiquidAI/LFM3-1.7B @Q4_K_M";
        provider = "custom";
        base_url = llamaSwapUrl;
        context_length = 64000;
      };

      providers = {
        "llama-swap" = {
          base_url = llamaSwapUrl;
          context_length = 64000;
          models = [
            "LiquidAI/LFM3-1.7B @Q4_K_M"
            "LiquidAI/LFM3-VL-2B @Q4_K_M"
            "LiquidAI/LFM3-Audio-2B @Q4_K_M"
            "LiquidAI/LFM3-Omni-2B @Q4_K_M"
            "LiquidAI/d1-2B @Q8_0"
            "LiquidAI/d1-Omni-2B @Q8_0"
            "[openbmb] MiniCPM-V 4.7 35B-A3B @Q4_K_M"
            "[openbmb] MiniCPM-V 4.7 35B-A3B @Q4_K_M [DSpark]"
            "[openbmb] MiniCPM-V 4.7 1B @Q8_0"
            "[openbmb] MiniCPM-V 4.7 1B @Q8_0 [DSpark]"
            "[openbmb] MiniCPM-OCR 1.0 @Q8_0"
            "[openbmb] MiniCPM-OCR 1.0 @Q8_0 [DSpark]"
            "[openbmb] MiniCPM-OCR Jev @Q8_0"
          ];
        };
      };

      model_aliases = {
        "lfm3" = llamaSwapAlias "LiquidAI/LFM3-1.7B @Q4_K_M";
        "lfm3-vl" = llamaSwapAlias "LiquidAI/LFM3-VL-2B @Q4_K_M";
        "lfm3-audio" = llamaSwapAlias "LiquidAI/LFM3-Audio-2B @Q4_K_M";
        "lfm3-omni" = llamaSwapAlias "LiquidAI/LFM3-Omni-2B @Q4_K_M";

        # d1 models are decision models. They answer on /v1/systemone, not the
        # chat-completions API, so they are listed for completeness only.
        "d1" = llamaSwapAlias "LiquidAI/d1-2B @Q8_0";
        "d1-omni" = llamaSwapAlias "LiquidAI/d1-Omni-2B @Q8_0";

        "minicpm-v" = llamaSwapAlias "[openbmb] MiniCPM-V 4.7 35B-A3B @Q4_K_M [DSpark]";
        "minicpm-v-35b" = llamaSwapAlias "[openbmb] MiniCPM-V 4.7 35B-A3B @Q4_K_M [DSpark]";
        "minicpm-v-35b-plain" = llamaSwapAlias "[openbmb] MiniCPM-V 4.7 35B-A3B @Q4_K_M";
        "minicpm-v-1b" = llamaSwapAlias "[openbmb] MiniCPM-V 4.7 1B @Q8_0 [DSpark]";
        "minicpm-v-1b-plain" = llamaSwapAlias "[openbmb] MiniCPM-V 4.7 1B @Q8_0";

        "minicpm-ocr" = llamaSwapAlias "[openbmb] MiniCPM-OCR 1.0 @Q8_0 [DSpark]";
        "minicpm-ocr-plain" = llamaSwapAlias "[openbmb] MiniCPM-OCR 1.0 @Q8_0";
        "minicpm-ocr-jev" = llamaSwapAlias "[openbmb] MiniCPM-OCR Jev @Q8_0";
      };
    };
  };
}
