{ pkgs, unstable, inputs, ... }: {
  home.packages = with pkgs; [
    (unstable.ollama)
    (unstable.lmstudio)
    opencode
    opencode-desktop
    cursor-cli
    claude-code

    # Forces Vulkan
    (inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.vulkan)

    # pi-coding-agent with NodeJS
    (symlinkJoin {
      name = "pi-coding-agent-with-nodejs";
      paths = [ pkgs.pi-coding-agent ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/pi \
          --prefix PATH : ${lib.makeBinPath [ nodejs ]}
      '';
    }) // {
      meta = (pkgs.pi-coding-agent.meta or {}) // {
        mainProgram = "pi";
      };
    }
  ];
}
