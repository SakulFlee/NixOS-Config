{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: 
    let    
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable.outPath { 
          inherit system;
          config = { allowUnfree = true; };
      };

      sharedArgs = {
        inherit inputs home-manager unstable;
      };

      sharedOverlayModule = { ... }: {
        nixpkgs.overlays = [
          (final: prev: {
            lmstudio = unstable.lmstudio;
          })
        ];
      };
    in {
      nixosConfigurations = {
        Cindry = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = sharedArgs;
          modules = [ 
            ./hosts/cindry/configuration.nix 
            sharedOverlayModule
          ];
        };

        SteamDeck = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = sharedArgs;
          modules = [ 
            ./hosts/steamdeck/configuration.nix 
            sharedOverlayModule
          ];
        };
      };
    };
  };
}
