{ users }: { ... }: {
  imports = [
    (import hermes.nix {
      users = users;
    })

    ai/llama-cpp.nix
    ai/opencode.nix
  ];
}
