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

    # Temporatory NixGL integration.
    # TODO: remove it after https://github.com/nix-community/home-manager/pull/5355 is on 24.05.
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nix-community/home-manager/8bd6e0a1a805c373686e21678bb07f23293d357b/modules/misc/nixgl.nix";
      sha256 = "1krclaga358k3swz2n5wbni1b2r7mcxdzr6d7im6b66w3sbpvnb3";
    })
  ];

  # NixGL Integration.
  # Read: https://nix-community.github.io/home-manager/index.xhtml#sec-usage-gpu-non-nixos
  # Set primary GPU wrapper as mesa, and secondary GPU wrapper as nvidiaPrime
  # ("Prime" means it is for secondary GPU). Later, Call `config.lib.nixGL.wrap`
  # for programs using the primary GPU, and `config.lib.nixGL.wrapOffload` for
  # programs using the secondary GPU.
  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = [
    "mesa"
    "nvidiaPrime"
  ];

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
    # ===== PDFs =====
    unstable.zotero

    # ===== IM =====
    slack
    discord
    (config.lib.nixGL.wrap telegram-desktop)
    # (config.lib.nixGL.wrap zoom-us)

    # ===== Music =====
    (config.lib.nixGL.wrap spotify)

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
    # docker
    # docker-compose
    mu
    chezmoi
    tree-sitter
    timeshift-minimal
    (config.lib.nixGL.wrap owncloud-client)

    # ===== Writing =====
    # === Tex ===
    texlive.combined.scheme-full
    # === Markdown ===
    (config.lib.nixGL.wrap typora) # doesn't work

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
    opam
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
    # === Ruby ===
    rbenv

    # ===== Games =====
    # (config.lib.nixGL.wrap unstable.steam)
  ];

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Yawen Guan";
      userEmail = "yawen.guan.email@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
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
        # To get the correct titlebar in Wayland.
        linux_display_server = "x11";
      };
    };
    emacs = {
      enable = true;
    };
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
