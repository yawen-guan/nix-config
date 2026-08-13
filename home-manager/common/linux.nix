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
  ];

  programs = {
    kitty.package = (config.lib.nixGL.wrap pkgs.kitty);
    zsh.dotDir = config.home.homeDirectory;
  };

  services = {
    syncthing = {
      enable = true;
    };
    copyq = {
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
