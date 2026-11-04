{ config, lib, pkgs, ... }:
let
  # Python environment used by the Jupyter kernel and the `jupytext` CLI.
  jupyterPython = pkgs.python3.withPackages (ps: with ps; [
    pynvim
    ipykernel
    jupyter-client
    jupytext
    nbformat
    # Optional, for richer output rendering
    cairosvg
    pillow
  ]);
in {
  xdg.configFile."nvim" = {
    source = ./.;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    # Required for molten-nvim's Python remote plugin.
    withPython3 = true;
    # image.nvim is configured with the `magick_cli` processor, so it only
    # needs the ImageMagick CLI. The `magick` Lua rock (and thus luarocks)
    # is not required and should not be installed here.
    extraPackages = with pkgs; [
      imagemagick
      ghostscript
      jupyterPython
    ];
  };

  # molten-nvim writes its connection file here before the kernel starts.
  # jupyter_client 8.9 no longer creates this directory itself.
  home.activation.createJupyterRuntimeDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p -m 700 "${config.xdg.dataHome}/jupyter/runtime"
  '';

  # Register the Nix Python as a Jupyter kernel so `:MoltenInit python3` works.
  xdg.dataFile."jupyter/kernels/python3/kernel.json".text = builtins.toJSON {
    argv = [
      "${jupyterPython}/bin/python3"
      "-m"
      "ipykernel_launcher"
      "-f"
      "{connection_file}"
    ];
    display_name = "Python 3 (Nix)";
    language = "python";
    metadata = {
      debugger = true;
    };
  };
}
