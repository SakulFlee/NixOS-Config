{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nixfmt
    nixfmt-tree
  ];
}
