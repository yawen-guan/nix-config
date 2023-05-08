{ 
  config, 
  pkgs, 
  lib,
  ... 
}: let 
  nixGLWrap = import ./modules/nixgl { inherit pkgs lib; };
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "yawen";
  home.homeDirectory = "/home/yawen";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  imports = [ ./modules/applications ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = (with pkgs; [ 
    nixgl.auto.nixGLDefault

    # Text Editors
    obsidian

    # PDF & Papers
    zotero

    # Messagers & Meetings
    slack
    discord
    # telegram-desktop # installed via apt
    zoom-us

    # Password Manager
    bitwarden

    # Media
    spotify

    # Screenshots. 
    # - Enable Shortcut: https://flameshot.org/docs/guide/key-bindings/#linux.
    # - Config Shortcut: In KDE custom shortcuts and in application.
    flameshot 

    # Productivity
    # cerebro 
    # albert

    # Utils
    ripgrep
    nettools
    wmctrl
    fusuma # Multitouch gestures. Config file is at ~/.config/fusuma/config.yml. 
    xdotool
    uxplay

    # Programming
    sbt
    cmake
    scala_3
    scalafmt
    scala-cli

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ]);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/yawen/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
    # TERMINAL = "kitty";
  };

  # Chinese input.
  # For ubuntu with kde, use `sudo apt install --install-recommends fcitx5 fcitx5-chinese-addons` instead.
  # See https://wiki.debian.org/I18n/Fcitx5.
  # i18n.inputMethod.enabled = "fcitx5";
  # i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];

  # Help applications launcher find applications installed by home-manager.
  # See https://github.com/nix-community/home-manager/issues/1439#issuecomment-714830958.
  xdg.enable=true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
