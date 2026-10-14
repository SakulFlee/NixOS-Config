{ users }: { ... }: {
  imports = [
    (import ./hermes.nix {
      users = users;
    })

    ./llama-cpp.nix
    ./opencode.nix
  ];
}
