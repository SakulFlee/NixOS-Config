{ pkgs, ... }: {
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Binary cache for numtide/llm-agents.nix (flake inputs' nixConfig is not
    # inherited, so it has to be declared here).
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
}
