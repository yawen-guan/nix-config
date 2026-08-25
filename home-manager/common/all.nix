{
  lib,
  config,
  pkgs,
  homeManagerModules,
  sopsModules,
  overlays,
  ...
}:
{
  imports = [
    homeManagerModules
    sopsModules
  ];

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
    # ===== IM =====
    slack
    discord

    # ===== Utils =====
    wget
    fzf
    ripgrep
    ripgrep-all
    nettools
    fd
    rsync
    # isync
    autorandr
    mu
    tree-sitter
    openconnect
    ttfautohint
    ispell
    git-archive-all
    git-filter-repo
    pandoc
    progress
    # === Encryption ===
    age
    sops
    ssh-to-age
    # === Image ===
    flameshot
    inkscape
    pdf2svg
    librsvg
    graphviz
    imagemagick
    # === PDF ===
    zotero # extensions: zotero-better-bibtex, zotero-style
    pdftk
    diff-pdf

    # ===== Programming =====
    # === C / C++ ===
    cmake
    cmake-language-server
    libtool
    glibtool
    clang-tools
    # === CSS ===
    stylelint
    # === HTML ===
    html-tidy
    # === Nix ===
    nixfmt
    nixfmt-tree
    nix-prefetch-git
    nix-prefetch-github
    # === Python ===
    pyenv
    black # formatter
    # === Shell ===
    shfmt
    shellcheck
  ];

  programs = {
    # Let home manager install and manage itself.
    home-manager.enable = true;
    git = {
      enable = true;
      settings = {
        github.user = "yawen-guan";
        gitlab.user = "yawen-guan";
        gitlab."gitlab.epfl.ch".user = "yguan";
        user = {
          name = "Yawen Guan";
          email = "yawen.guan@proton.me";
        };
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
      font = {
        name = "Iosevka";
        size = 9;
      };
      settings = {
        enabled_layouts = "horizontal,stack,splits,tall,fat,vertical";
      };
    };
    emacs.enable = true;
    vscode = {
      enable = true;
      profiles.default = {
        enableUpdateCheck = false;
        extensions = (
          with pkgs.vscode-extensions;
          [
            bbenoist.nix
            vscodevim.vim
            mkhl.direnv
            rocq-prover.vsrocq
            ocamllabs.ocaml-platform
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
          "vim.useSystemClipboard" = true;
          "editor.unicodeHighlight.ambiguousCharacters" = false;
          # Keep the standard theme colors in the terminal.
          "terminal.integrated.minimumContrastRatio" = 1;
          "workbench.secondarySideBar.defaultVisibility" = "hidden";
          # "editor.minimap.enabled" = false;
        };
        keybindings = [
          {
            key = "f s";
            command = "workbench.action.files.save";
            when = "editorTextFocus && vim.mode == 'Normal'";
          }
        ];
      };
    };
  };
  xdg.configFile."kitty/ssh.conf".text = ''
    hostname vm
      color_scheme Duskfox
  '';
}
