{ users }: { ... }: {
  imports = [
    (import ai/_.nix {
      users = users;
    })

    dev/_.nix
    creative/_.nix
    files/_.nix
    kde/_.nix
    games/_.nix
    internet/_.nix
    media/_.nix
    office/_.nix
    security/_.nix
    social/_.nix
    system/_.nix
  ];
}
