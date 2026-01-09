{
  description = "NixOS Daily Driver";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = inputs@{ self, nixpkgs, nixgl, nixpkgs-unstable, home-manager, home-manager-unstable, ... }:
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

          home-manager-unstable.nixosModules.home-manager
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
        extraSpecialArgs = {
          nixgl = nixgl;
        };
        modules = [
          ./home-gl.nix
          ({ ... }: {
            home.username = "administrator";
            home.homeDirectory = "/home/administrator";
            home.stateVersion = "25.11";
          })
        ];
      };
    };
}
