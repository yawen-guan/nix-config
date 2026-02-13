# Home-manager configuration file for infinitybook.
# (It replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    outputs.homeManagerModules
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  targets.genericLinux.nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "NotoSerif Nerd Font" ];
        sansSerif = [ "Ubuntu Nerd Font" ];
        monospace = [ "Ubuntu Nerd Font" ];
      };
    };
  };

  home = {
    username = "vmiya";
    homeDirectory = "/home/vmiya";
    stateVersion = "23.05";
  };

  home.packages = with pkgs; [
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

    # ===== Utils =====
    wget
    fzf
    ripgrep
    fd
    rsync
    tree-sitter
    openconnect
    ttfautohint
    ispell
  ];

  programs = {
    # Let home manager install and manage itself.
    home-manager.enable = true;
    git = {
      enable = true;
      settings = {
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

  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;

  systemd.user.startServices = "sd-switch";
}
