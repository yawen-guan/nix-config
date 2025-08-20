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
  common-all = import ./common/all.nix {
    inherit lib config pkgs;
    homeManagerModules = outputs.homeManagerModules;
    overlays = outputs.overlays;
  };
in
{
  imports = [
    common-all
    ./common/linux.nix
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
    username = "miya";
    homeDirectory = "/home/miya";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
  };

  programs.firefox.enable = true;

  # More packages.
  home.packages = with pkgs; [
    telegram-desktop
    spotify
  ];
}
