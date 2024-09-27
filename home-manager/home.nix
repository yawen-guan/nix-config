# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  nixGLIntel = inputs.nixGL.packages."${pkgs.system}".nixGLIntel;
  nixGLDefault = inputs.nixGL.packages."${pkgs.system}".nixGLDefault;
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    outputs.homeManagerModules

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    # NixGL integration.
    # See: https://github.com/nix-community/home-manager/issues/3968#issuecomment-2135919008
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "01dkfr9wq3ib5hlyq9zq662mp0jl42fw3f6gd2qgdf8l8ia78j7i";
    })
  ];

  # NixGL integration.
  # See: https://github.com/nix-community/home-manager/issues/3968#issuecomment-2135919008
  nixGL.prefix = "${nixGLIntel}/bin/nixGLIntel";
  # nixGL.prefix = "${nixGLDefault}/bin/nixGL";

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.emacs-overlay

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
    nixGLIntel
    # nixGLDefault

    # ===== PDFs =====
    zotero_7

    # ===== IM =====
    slack
    discord
    (config.lib.nixGL.wrap telegram-desktop)

    # ===== Music =====
    # (config.lib.nixGL.wrap spotify)

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
    isync
    autorandr
    ttfautohint
    docker
    mu
    chezmoi
    tree-sitter

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

    # ===== Games =====
    # (config.lib.nixGL.wrap unstable.steam)
  ];

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Yawen Guan";
      userEmail = "yawen.guan.email@gmail.com";
    };
    vim.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    kitty = {
      enable = true;
      package = (config.lib.nixGL.wrap pkgs.kitty);
      font.name = "Iosevka";
      settings = {
        enabled_layouts = "horizontal,stack,splits,tall,fat,vertical";
        linux_display_server = "x11";
      };
    };
    # emacs = {
    #  enable = true; 
    #  package = pkgs.emacs-git;
    # };
  };

  # Make installed apps show up in Gnome.
  # Read: https://github.com/nix-community/home-manager/issues/1439
  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
