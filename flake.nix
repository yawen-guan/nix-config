{
  description = "Home Manager configuration of yawen";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl.url = "github:guibou/nixGL";
  };

  outputs = inputs: let
      system = "x86_64-linux";
    in {
      defaultPackage.x86_64-linux = inputs.home-manager.defaultPackage.x86_64-linux;

      homeConfigurations = import ./home-config.nix {
        inherit inputs system;
      };
    };
}
