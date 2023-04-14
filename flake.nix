{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Home-manager already..
      # Includes its own packages, but we can specify even more under the
      # 'nixpkgs' package manager.
    };
  };

  outputs = {self, nixpkgs, home-manager}: # Our 'includes'
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system; # Remember, we just declared the system as x86..
        config.allowUnfree = true; # Allow proprietary software
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      # Define our hostname as 'nixos'
      nixos = lib.nixosSystem {
        inherit system;
        # make our system config realized in current dir. Also,
        # our hardware config:
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.daniel = {
              imports = [./home.nix];
            };
          }
        ];
      };
      # Specify additional users here with 'nixosConfigurations = {'
      # With their own modules too!
    };
    hmConfig = {
      nixos = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./home.nix
          {
           home = {
              username = "daniel";
              homeDirectory = "/home/daniel";
              stateVersion = "22.11";
           }; 
          }
        ];
      };
    };
  };
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
