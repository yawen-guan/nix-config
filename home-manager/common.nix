{
  lib,
  config,
  pkgs,
  homeManagerModules,
  overlays,
  ...
}:
{
  imports = [ homeManagerModules ];

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

  # Allow packages to discover user fonts.
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "NotoSerif Nerd Font" ];
      sansSerif = [ "Ubuntu Nerd Font" ];
      monospace = [ "Ubuntu Nerd Font" ];
    };
  };

  home.packages = with pkgs; [
    # ===== Mail =====
    protonmail-desktop

    # ===== PDFs =====
    unstable.zotero

    # ===== IM =====
    slack
    discord

    # ===== Notes =====
    p3x-onenote

    # ===== Browsers =====
    google-chrome

    # ===== Utils =====
    todoist-electron
    # planify
    flameshot
    fzf
    ripgrep
    ripgrep-all
    nettools
    # crow-translate
    fd
    rsync
    rsnapshot
    isync
    autorandr
    # docker
    # docker-compose
    mu
    chezmoi
    tree-sitter
    # timeshift-minimal
    openconnect
    vscode

    # ===== Fonts =====
    iosevka
    nerdfonts

    # === Tex ===
    texlive.combined.scheme-full

    # ===== Programming =====
    # === Scala ===
    unstable.scala-next
    # unstable.scala
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
    coq
    # === Python ===
    pyenv
    # === NodeJS ===
    nodejs
    # === Ruby ===
    rbenv
    # === Java ===
    jdk8
    # === Rust ===
    rustup
  ];

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Yawen Guan";
      userEmail = "yawen.guan@proton.me";
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
}
