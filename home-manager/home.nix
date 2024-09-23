# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    outputs.homeManagerModules

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

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

  home = {
    username = "yawen";
    homeDirectory = "/home/yawen";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # ===== Wrapper =====
    # nixgl requires '--impure' attribute.
    ## nixgl.auto.nixGLDefault

    # ===== PDFs =====
    zotero_7

    # ===== IM =====
    slack
    discord
    ## (nixGL telegram-desktop)

    # ===== Music =====
    # (nixGL spotify)

    # ===== Utils =====
    planify
    flameshot
    fzf
    ripgrep
    ripgrep-all
    nettools
    crow-translate
    fd
    rsync
    rsnapshot
    autorandr
    ttfautohint
    docker
    mu
    isync

    # ===== Writing =====
    # === Tex ===
    texlive.combined.scheme-full
    # === Markdown ===
    typora

    # ===== Programming =====
    # === Scala ===
    unstable.scala
    unstable.sbt
    unstable.metals
    unstable.scalafmt
    # === C / C++ ===
    cmake
    cmake-language-server
    libtool
    clang-tools
    # === OCaml ===
    ocaml
    ocamlformat
    ocamlPackages.ocp-indent
    ocamlPackages.findlib
    ocamlPackages.dune_3
    ocamlPackages.utop
    ocamlPackages.merlin
    # === Shell ===
    shfmt
    shellcheck
    # === Nix ===
    nixfmt-rfc-style
    nix-prefetch-git
    nix-prefetch-github
    # === Coq ===
    coq_8_18
    # === Python ===
    pyenv
    # === NodeJS ===
    nodejs
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
