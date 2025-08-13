# Home-manager configuration file for infinitybook.
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
  common-all = import ./common/all.nix {
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

    common-all
    inputs.mac-app-util.homeManagerModules.default
  ];

  home = {
    username = "yawen";
    homeDirectory = "/Users/yawen";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
  };

  # More packages.
  home.packages = with pkgs; [
    # karabiner-elements
    telegram-desktop
  ];

  programs.kitty = {
    package = pkgs.kitty;
    # font.size = "12";
  };
}
