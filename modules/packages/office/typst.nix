{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    typst
    typststyle
    typst-live
    tapstwriter
  ];
}
