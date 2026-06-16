{ ... }: {
  imports = [
    ./kde/_.nix 
    ./audio.nix                 
    ./experimental-features.nix 
    ./fonts.nix                 
    ./gpg.nix                   
    ./home-manager.nix          
    ./kernel.nix                
    ./locale.nix                
    ./nas.nix                   
    ./networking.nix            
    ./nix-gc.nix                
    ./nixpkgs-unfree.nix        
    ./printing.nix              
    ./sops.nix                  
    ./ssh.nix                   
    ./system-packages.nix       
    ./system-state.nix          
    ./touchpad.nix              
    ./wayland.nix              
    ./zsh.nix                   
  ];
}
