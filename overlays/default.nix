# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  # Emacs overlay with emacs 29.4 (2024-06-20)
  # See: https://github.com/nix-community/emacs-overlay
  emacs-overlay = import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/26dc8270e154711306a25d0d2921bd6dda545521.tar.gz;
    });
}
