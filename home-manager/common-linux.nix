{
  lib,
  config,
  pkgs,
  overlays,
  ...
}:
{
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      overlays.additions
      overlays.modifications
      overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  imports = [
    # Temporatory NixGL integration.
    # TODO: remove it after https://github.com/nix-community/home-manager/pull/5355 is on 24.05.
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nix-community/home-manager/8bd6e0a1a805c373686e21678bb07f23293d357b/modules/misc/nixgl.nix";
      sha256 = "1krclaga358k3swz2n5wbni1b2r7mcxdzr6d7im6b66w3sbpvnb3";
    })
  ];

  home.packages = with pkgs; [
    # ===== Utils =====
    planify
    crow-translate
    timeshift-minimal
    ttfautohint
  ];

  programs.kitty.package = (config.lib.nixGL.wrap pkgs.kitty);

  # Make installed apps show up in Gnome.
  # Read: https://github.com/nix-community/home-manager/issues/1439
  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
