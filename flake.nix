{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-sunshine-pr.url = "github:NixOS/nixpkgs/pull/521906/head";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-sunshine-pr, home-manager, ... }: {
    nixosConfigurations.Cindry = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { 
        inherit home-manager; 
        unstable = import nixpkgs-unstable.outPath { 
          system = "x86_64-linux"; 
          config = { allowUnfree = true; }; 
        }; 
        sunshine-pr = import nixpkgs-sunshine-pr.outPath { 
          system = "x86_64-linux"; 
        }; 
      };
      modules = [ 
        ./hosts/cindry/configuration.nix 
        ({ unstable, sunshine-pr, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              lmstudio = unstable.lmstudio;
              sunshine = sunshine-pr.sunshine;
            })
          ];
        })
      ];
    };
  };
}
