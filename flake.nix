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

    llama-cpp = {
      url = "github:ggml-org/llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fansly-recorder = {
      url = "github:SakulFlee/FanslyRecorder";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane = {
      url = "github:ipetkov/crane";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, nix-flatpak, ... }@inputs: 
    let    
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable.outPath {
          localSystem = { inherit system; };
          config = { allowUnfree = true; };
      };

      sharedArgs = {
        inherit inputs home-manager unstable;
      };
    in {
      nixosConfigurations = {
      Evil-Donkey = nixpkgs.lib.nixosSystem {
        specialArgs = sharedArgs;
        modules = [
          { nixpkgs.hostPlatform = system; }
          ./hosts/evil-donkey/configuration.nix 
        ];
      };

      Cindry = nixpkgs.lib.nixosSystem {
        specialArgs = sharedArgs;
        modules = [
          { nixpkgs.hostPlatform = system; }
          ./hosts/cindry/configuration.nix 
        ];
      };

      SteamDeck = nixpkgs.lib.nixosSystem {
        specialArgs = sharedArgs;
        modules = [
          { nixpkgs.hostPlatform = system; }
          ./hosts/steamdeck/configuration.nix 
        ];
      };
    };
  };
}
