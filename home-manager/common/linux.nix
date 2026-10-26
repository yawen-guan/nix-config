{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [ ];

  home.packages = with pkgs; [
    rsnapshot
    shotwell
    diffpdf
    resources
    libreoffice

    # ===== Fonts =====
    iosevka
    julia-mono
    nerd-fonts.noto
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    nerd-fonts.inconsolata
    nerd-fonts.caskaydia-cove
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    libertinus
    alegreya
    alegreya-sans
    source-sans
    symbola
    # chinese
    lxgw-wenkai

    # ===== Browsers =====
    google-chrome

    # ===== Programming =====
    # === Docker ===
    # docker # installed rootless mode following https://docs.docker.com/engine/security/rootless/
    dockfmt
    # === Haskell ===
    ghc
    haskell-language-server
    cabal-install
    # ormolu # formatter
    fourmolu # formatter used by emacs package `apheleia` by default
    haskellPackages.hoogle
    # === Java ===
    jdk8
    # === Markdown ===
    obsidian # knowledage base
    # === OCaml ===
    opam
    # ocaml
    # ocamlformat
    # ocamlPackages.ocp-indent
    # ocamlPackages.findlib
    # ocamlPackages.dune_3
    # ocamlPackages.utop
    # ocamlPackages.merlin
    # === Scala ===
    unstable.scala-next # unstable.scala
    unstable.sbt
    unstable.metals
    unstable.scalafmt
    unstable.scala-cli
    # === Rust ===
    # rustup
    # === Tex ===
    texlive.combined.scheme-full
  ];

  programs = {
    kitty.package = (config.lib.nixGL.wrap pkgs.kitty);
    zsh.dotDir = config.home.homeDirectory;
    emacs.package = pkgs.emacs-pgtk; # For wayland
  };

  services = {
    syncthing = {
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
}
