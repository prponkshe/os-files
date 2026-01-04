{
  description = "NixOS Daily Driver";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {     
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations.northee-dtp = nixpkgs-unstable.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./noctalia.nix

	    home-manager.nixosModules.home-manager 
      	{
	        home-manager = {
	          useGlobalPkgs = true;
	          useUserPackages = true;
	          users.northee = {
                imports = [ ./home.nix ];
                  home.username = "northee";
           home.homeDirectory = "/home/northee";
           home.stateVersion = "26.05";
              };
	          backupFileExtension = "backup";
          };
	      }
      ];
    };
    homeConfigurations.work-ltp = home-manager.lib.homeManagerConfiguration {
       inherit pkgs;
       modules = [ 
         ./home.nix 
         ({ ... }: {
           home.username = "administrator";
           home.homeDirectory = "/home/administrator";
           home.stateVersion = "25.11";
         })
       ];
    };
  };
}
