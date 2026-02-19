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

    # ===== Fonts =====
    iosevka
    nerd-fonts.noto
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    nerd-fonts.inconsolata
    noto-fonts-cjk-serif
    libertinus
    alegreya
    alegreya-sans
    source-sans
  ];

  programs = {
    kitty.package = (config.lib.nixGL.wrap pkgs.kitty);
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
