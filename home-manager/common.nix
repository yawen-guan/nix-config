{
  lib,
  config,
  pkgs,
  homeManagerModules,
  ...
}:
{
  imports = [ homeManagerModules ];

  home.packages = with pkgs; [
    # ===== PDFs =====
    unstable.zotero

    # ===== IM =====
    slack
    discord

    # ===== Utils =====
    # planify
    flameshot
    fzf
    ripgrep
    ripgrep-all
    nettools
    # crow-translate
    fd
    rsync
    # rsnapshot
    isync
    autorandr
    # docker
    # docker-compose
    mu
    chezmoi
    tree-sitter
    # timeshift-minimal
    openconnect

    # === Tex ===
    texlive.combined.scheme-full

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
