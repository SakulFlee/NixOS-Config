{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: {
    nixosConfigurations.Cindry = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { 
        inherit inputs; 
        inherit home-manager; 
        unstable = import nixpkgs-unstable.outPath { 
          system = "x86_64-linux"; 
          config = { allowUnfree = true; }; 
        }; 
      };
      modules = [ 
        ./hosts/cindry/configuration.nix 
        ({ unstable, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              lmstudio = unstable.lmstudio;
            })
          ];
        })
      ];
    };

    nixosConfigurations.SteamDeck = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { 
        inherit inputs; 
        inherit home-manager; 
        unstable = import nixpkgs-unstable.outPath { 
          system = "x86_64-linux"; 
          config = { allowUnfree = true; }; 
        }; 
      };
      modules = [ 
        ./hosts/steamdeck/configuration.nix 
        ({ unstable, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              lmstudio = unstable.lmstudio;
            })
          ];
        })
      ];
    };
  };
}
