{
  description = "Nini's config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs"; # Name of nixpkgs input you want to use

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, aagl, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
    
      nixosConfigurations.chalknix = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [ 
            ./hosts/chalknix/configuration.nix
            {
              imports = [ aagl.nixosModules.default ];
              nix.settings = aagl.nixConfig;
              programs.anime-game-launcher.enable = true;
              programs.honkers-railway-launcher.enable = true;
            }
            inputs.home-manager.nixosModules.default
          ];
        };
      nixosConfigurations.nzinni = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/work/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
    };
}
