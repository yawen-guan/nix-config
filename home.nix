{ config, pkgs, lib, ... }:
let
  # nixgl = pkgs.nixgl; 
  nixGLWrap = import ./modules/linux/nixgl { inherit pkgs lib; };
in
{
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
  home.stateVersion = "23.05"; # Please read the comment before changing.

  imports = [ ./modules/linux/apps ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = (with pkgs; [
    # After switching to nvidia or switching back Intel, remember to run 
    # `home-manager switch --impure` to make sure nixGL find the correct driver. 
    # Otherwise there's an error message related to broken OpenGL when trying to 
    # run programs like kitty. 
    nixgl.auto.nixGLDefault

    ##### Text editor. #####
    obsidian
    # typora # Installed via apt, otherwise it failed to load appmenu-gtk-module and canberra-gtk-module. Tried (nixGLWrap typora). 

    ##### PDF reader. #####
    zotero

    ##### IM. #####
    slack
    discord

    ##### Productivity. #####
    morgen
    # todoist # Installed via snap, according to the official website.

    ##### Utils. #####
    flameshot
    # spotify # Installed via snap.
    ripgrep
    nettools
    wmctrl
    fusuma # Multitouch gestures. Config file is at ~/.config/fusuma/config.yml. 
    xdotool
    # uxplay
    # goldendict # Installed via apt.
    crow-translate
    # rclone # Sync cloud drives.
    # nordvpn # Installed via apt.
    # logiops # Installed via official local building (cmake).
    # cron
    # mtools # Installed via apt.
    # autorandr
    # vlc
    # backintime # Backup tool. Installed via apt.
    electron

    ##### Programming. #####
    cmake
    sbt
    scala_3
    scalafmt
    scala-cli
    # coq_8_15
    # coq_8_16
    coq_8_17
    ocaml
    opam
    nixpkgs-fmt

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
  };

  # Help applications launcher find applications installed by home-manager.
  # See https://github.com/nix-community/home-manager/issues/1439#issuecomment-714830958.
  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
