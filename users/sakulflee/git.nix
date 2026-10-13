{ pkgs, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "@SakulFlee | Lukas Weber";
        email = "dev@sakul-flee.de";
        signingKey = "93842616D9E2EF9B41078EB833CC460FF18CDFFC";
      };
      commit.gpgsign = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      credential.helper = "store";

      # Fetch other AGIT branches
      remote.origin.fetch = "+refs/pull/*/head:refs/remotes/origin/pr/*";
    };
  };
}
