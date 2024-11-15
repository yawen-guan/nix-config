# Home-manager configuration file for homepc.
# (It replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  common = import ./common.nix {
    inherit lib config pkgs;
    homeManagerModules = outputs.homeManagerModules;
    overlays = outputs.overlays;
  };
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    # outputs.homeManagerModules

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    common
    ./common-linux.nix
  ];

  # NixGL Integration.
  # Read: https://nix-community.github.io/home-manager/index.xhtml#sec-usage-gpu-non-nixos
  # Set primary GPU wrapper as mesa, and secondary GPU wrapper as nvidiaPrime
  # ("Prime" means it is for secondary GPU). Later, Call `config.lib.nixGL.wrap`
  # for programs using the primary GPU, and `config.lib.nixGL.wrapOffload` for
  # programs using the secondary GPU.
  nixGL.packages = inputs.nixgl.packages;
  # nixGL.defaultWrapper = "nvidia";
  # nixGL.installScripts = [ "nvidia" ];

  home = {
    username = "yawen";
    homeDirectory = "/home/yawen";
  };

  # More packages.
  home.packages = with pkgs; [
    # ===== GUIs =====
    # (config.lib.nixGL.wrap telegram-desktop) # Gtk-Message: Failed to load module "canberra-gtk-module"
    # (config.lib.nixGL.wrap zoom-us) # does not work
    # (config.lib.nixGL.wrap owncloud-client) # Gtk-Message: Failed to load module "canberra-gtk-module"
    # (config.lib.nixGL.wrap typora) # does not work
    # (config.lib.nixGL.wrap spotify) # Gtk-Message: Failed to load module "canberra-gtk-module"
    # (config.lib.nixGL.wrap unstable.steam)
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
