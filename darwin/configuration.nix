{ config, pkgs, lib, ... }:
{ 
  imports = []; 

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Enable alternative shell support in nix-darwin.
  programs.zsh.enable = true; 
  # programs.fish.enable = true;
  
  # Network related settings. 
  networking.hostName = "yg-macbook";

  users.users.yawen = {
    name = "yawen";
    home = "/Users/yawen";
    # shell = "#{config.home-manager.users.yawen.programs.zsh.package}/bin/zsh";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
