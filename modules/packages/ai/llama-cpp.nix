{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ 
    (inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.rocm)
  ];
}
