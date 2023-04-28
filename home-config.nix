{
  inputs,
  system,
  ...
}:
with inputs; let
  pkgs = import nixpkgs {
    inherit system;

    overlays = [
      (import ./modules/overlays)
      nixgl.overlay
    ];

    config = {
      allowUnfree = true;
      # See https://github.com/nix-community/home-manager/issues/2942. 
      # allowUnfreePredicate = (pkg: true);
    };
  };

  imports = [
    ./home.nix
  ];
in {
  yawen = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    modules = [{inherit imports;}];
  };
}