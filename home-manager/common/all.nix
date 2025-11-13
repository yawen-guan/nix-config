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

  fonts = {
    fontconfig = {
      # Allow packages to discover user fonts.
      enable = true;
      defaultFonts = {
        serif = [ "NotoSerif Nerd Font" ];
        sansSerif = [ "Ubuntu Nerd Font" ];
        monospace = [ "Ubuntu Nerd Font" ];
      };
    };
  };

  home.packages = with pkgs; [
    # ===== PDFs =====
    unstable.zotero # extensions: zotero-better-bibtex, zotero-style

    # ===== IM =====
    slack
    discord

    # ===== Browsers =====
    google-chrome

    # ===== Utils =====
    wget
    flameshot
    fzf
    ripgrep
    ripgrep-all
    nettools
    fd
    rsync
    # isync
    autorandr
    # docker
    # docker-compose
    mu
    chezmoi
    tree-sitter
    openconnect
    ttfautohint
    ispell
    graphviz
    inkscape

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
    glibtool
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
    nixfmt-tree
    nix-prefetch-git
    nix-prefetch-github
    # === Coq ===
    coq
    # coqPackages.serapi
    coqPackages.equations
    # === Python ===
    pyenv
    # === Javascript & Typescript ===
    nodejs
    nodePackages.prettier
    yarn
    # === Ruby ===
    rbenv
    # === Java ===
    jdk8
    # === Rust ===
    rustup
    # === Haskell ===
    ghc
    haskell-language-server
    cabal-install
    # ormolu # formatter
    fourmolu # formatter used by emacs package `apheleia` by default
    haskellPackages.hoogle
  ];

  programs = {
    # Let home manager install and manage itself.
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Yawen Guan";
      userEmail = "yawen.guan@proton.me";
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "vim";
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
    vscode = {
      enable = true;
      profiles.default = {
        enableUpdateCheck = false;
        extensions = (
          with pkgs.vscode-extensions;
          [
            bbenoist.nix
            vscodevim.vim
          ]
        );
        userSettings = {
          "workbench.colorTheme" = "Quiet Light";
          "vim.insertModeKeyBindings" = [
            {
              # Exit insert mode with "jk"
              "before" = [
                "j"
                "k"
              ];
              "after" = [ "<Esc>" ];
            }
          ];
          "editor.fontFamily" = "Iosevka";
        };
      };
    };
  };
}
