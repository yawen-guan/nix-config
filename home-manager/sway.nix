{
  config,
  lib,
  pkgs,
  ...
}:

let
  wallpaper = "${config.home.homeDirectory}/Pictures/wallpapers/jellyfish.jpg";
  builtinScreen = "California Institute of Technology 0x1402 Unknown";
  externalScreen = "LG Electronics LG ULTRAFINE 211MADHQ5B34";

  # Wrapper for system (apt-installed) sway, swaymsg, swaybar
  systemSway = pkgs.runCommand "system-sway" { } ''
    mkdir -p "$out/bin"

    cat > "$out/bin/sway" <<'EOF'
    #!/bin/sh
    add_to_path() {
      case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
      esac
    }
    add_to_path "${config.home.profileDirectory}/bin"
    add_to_path "/nix/var/nix/profiles/default/bin"
    export PATH
    exec /usr/bin/sway "$@"
    EOF

    cat > "$out/bin/swaymsg" <<'EOF'
    #!/bin/sh
    exec /usr/bin/swaymsg "$@"
    EOF

    cat > "$out/bin/swaybar" <<'EOF'
    #!/bin/sh
    exec /usr/bin/swaybar "$@"
    EOF

    chmod +x "$out/bin/"*
  '';

  # Read https://github.com/NixOS/nixpkgs/issues/531950; may not need it later.
  spotifyWayland = pkgs.symlinkJoin {
    name = "spotify-wayland";
    paths = [ (config.lib.nixGL.wrap pkgs.spotify) ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/spotify \
        --unset DISPLAY
    '';
  };

in
{
  # Disable home-manager from managing xdg portal and load the system configs.
  # Read https://github.com/nix-community/home-manager/issues/4922#issuecomment-1900844062
  xdg.portal.enable = false;

  # Need to copy it to /usr/share once:
  #  sudo cp $HOME/.local/share/wayland-sessions/sway-home-manager.desktop /usr/share/wayland-sessions/sway-home-manager.desktop
  xdg.dataFile."wayland-sessions/sway-home-manager.desktop".text = ''
    [Desktop Entry]
    Name=Sway (Home Manager)
    Comment=Sway using the Home Manager wrapper
    Exec=${config.home.profileDirectory}/bin/sway
    Type=Application
    DesktopNames=sway
  '';

  home.packages = with pkgs; [
    spotifyWayland

    nwg-displays

    # used by waybar
    pavucontrol
    peaclock
    playerctl
    brightnessctl

    # screenshot
    sway-contrib.grimshot

    # ===== apt-installed packages =====
    # sway
    # swaylock # needs to be integrate against the system's PAM library
    # btop # resource monitor
  ];

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";

    NIXOS_OZONE_WL = "1"; # ozone wayland support

    # fcitx5 is installed via apt:
    #   sudo apt install fcitx5 fcitx5-chinese-addons fcitx5-config-qt fcitx5-rime fcitx5-mozc
    XMODIFIERS = "@im=fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    SDL_IM_MODULE = "fcitx";
  };

  programs = {
    yazi = {
      enable = true;
      shellWrapperName = "y";
    };
    waybar = {
      enable = true;
      systemd = {
        enable = true;
        # Start waybar with the sway-specific session target to avoid launching
        # it before the wayland session is ready.
        targets = [ "sway-session.target" ];
      };
    };
    wlogout.enable = true;
    swaylock = {
      enable = true;
      package = null; # use /usr/bin/swaylock instead
      settings = {
        image = wallpaper;
        scaling = "fill";
        indicator-radius = 100;
        indicator-thickness = 8;
        show-failed-attempts = true;
      };
    };
  };

  xdg.configFile."waybar" = {
    source = ../dotfiles/waybar;
    recursive = true;
  };

  services = {
    elephant = {
      enable = true;
      # Use unstable to avoid https://github.com/abenz1267/elephant/issues/270
      package = pkgs.unstable.elephant;
    };
    walker = {
      enable = true;
      enableElephantIntegration = true;
      systemd.enable = true;
      settings = {
        # See https://github.com/swaywm/sway/issues/8560#issuecomment-2854142481
        as_window = true;
      };
    };
    swayidle = {
      enable = true;
      events = {
        # lock the screen before going to sleep
        before-sleep = "/usr/bin/swaylock";
      };
      timeouts = [
        # first, lock after 5 minutes of idling
        {
          timeout = 300;
          command = "${pkgs.runtimeShell} -c '/usr/bin/swaylock -f &'";
        }
        # then, turn off display after another 30 second of idling
        {
          timeout = 330;
          command = "/usr/bin/swaymsg 'output * power off'";
          resumeCommand = "/usr/bin/swaymsg 'output * power on'";
        }
      ];
    };
    swaync = {
      enable = true;
    };
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "always";
      settings = {
        program_options = {
          # Lock device after unmounting
          lock = true;
        };
      };
    };
    network-manager-applet = {
      enable = true;
    };
    blueman-applet = {
      enable = true;
    };
  };

  wayland.systemd.target = "sway-session.target";

  # Debug note:
  # One can print systemd PATH by running:
  #   `systemctl --user show-environment | sed -n 's/^PATH=//p'`
  # One can print sway PATH by running:
  #   `sway_pid=$(pgrep -xo sway) tr '\0' '\n' < "/proc/$sway_pid/environ" | sed -n 's/^PATH=//p'`
  # Both of them should have the nix paths.
  wayland.windowManager.sway = {
    enable = true;

    # Use /usr/bin/sway instead.
    package = systemSway;

    # Config validation runs inside the Nix sandbox, where /usr/bin/sway
    # is unavailable.
    checkConfig = false;

    # Read https://wiki.archlinux.org/title/Sway#Configuration
    extraConfig = ''
      include /etc/sway/config.d/*
    '';

    systemd = {
      enable = true;
      variables = [
        # Default values
        "DISPLAY"
        "WAYLAND_DISPLAY"
        "SWAYSOCK"
        "XDG_CURRENT_DESKTOP"
        "XDG_SESSION_TYPE"
        "NIXOS_OZONE_WL"
        "XCURSOR_THEME"
        "XCURSOR_SIZE"
        # Make PATH visible to systemd user services,
        # so that Walker/Elephant can launch nix-installed applications
        "PATH"
        # Make desktop-entry directories visible too,
        # so that Walker/Elephant can find the .desktop files
        "XDG_DATA_DIRS"
      ];
    };

    config = {
      modifier = "Mod4"; # super key
      input = {
        "type:keyboard" = {
          # swap ctrl and caps, use right alt as compose key
          xkb_options = "ctrl:swapcaps,compose:ralt";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };
      output = {
        "${builtinScreen}" = {
          scale = "2";
          mode = "2880x1800@90Hz";
          position = "0 0";
        };
        "${externalScreen}" = {
          scale = "2";
          mode = "3840x2160@60Hz";
          position = "1440 0";
        };
      };
      workspaceOutputAssign = [
        {
          workspace = "1";
          output = builtinScreen;
        }
        {
          workspace = "2";
          output = externalScreen;
        }
      ];
      bars = [ ]; # No swaybar.
      startup = [
        {
          command = "/usr/bin/swaybg -i ${wallpaper} -m fill";
        }
        {
          command = "/usr/bin/fcitx5 -d";
        }
      ];
      # See https://github.com/swaywm/sway/issues/8560#issuecomment-2854142481
      window.commands = [
        {
          criteria.app_id = "dev.benz.walker";
          command = "border none, floating enable";
        }
      ];
      keybindings = lib.mkOptionDefault {
        "Mod4+Return" = "exec kitty";
        "Mod4+m" = "exec emacsclient -c -a emacs";
        "Mod4+x" = "exec firefox";
        "Mod4+d" = "exec walker";
        "Mod4+u" = "exec walker --provider windows";
        "Mod4+c" = "exec walker --provider clipboard";
        "Mod4+o" = "exec walker --provider bluetooth";
        "Mod4+comma" = "focus output left";
        "Mod4+period" = "focus output right";
        "Mod4+Shift+comma" = "move container to output left; focus output left";
        "Mod4+Shift+period" = "move container to output right; focus output right";
        "Mod4+Shift+9" = "move workspace to output left";
        "Mod4+Shift+0" = "move workspace to output right";
        "Mod4+bracketleft" = "workspace prev_on_output";
        "Mod4+bracketright" = "workspace next_on_output";
        "Mod4+Shift+bracketleft" = "move container to workspace prev_on_output; workspace prev_on_output";
        "Mod4+Shift+bracketright" = "move container to workspace next_on_output; workspace next_on_output";
        "Mod4+Shift+1" = "move container to workspace number 1; workspace number 1";
        "Mod4+Shift+2" = "move container to workspace number 2; workspace number 2";
        "Mod4+Shift+3" = "move container to workspace number 3; workspace number 3";
        "Mod4+Shift+4" = "move container to workspace number 4; workspace number 4";
        "Mod4+Shift+5" = "move container to workspace number 5; workspace number 5";
        "Mod4+Shift+6" = "move container to workspace number 6; workspace number 6";
        "Mod4+Shift+7" = "move container to workspace number 7; workspace number 7";
        "Mod4+Shift+8" = "move container to workspace number 8; workspace number 8";
        "Mod4+minus" = "move scratchpad";
        "Mod4+plus" = "scratchpad show";

        # grouping step 1: select the first window.
        "Mod4+g" = "unmark group-1; mark group-1";
        # grouping step 2: group the focused window with the selected window.
        "Mod4+Shift+g" =
          "mark group-2; "
          + "[con_mark=group-1] focus; "
          + "split horizontal; "
          + "[con_mark=group-2] focus; "
          + "move container to mark group-1; "
          + "[con_mark=group-1] layout tabbed; "
          + "[con_mark=group-1] focus; "
          + "unmark group-1; "
          + "unmark group-2";

        # lock
        "Mod4+Escape" = "exec /usr/bin/swaylock";
        # logout screen
        "Mod4+Shift+Escape" = "exec wlogout";
        # screenshots
        "Print" = "exec grimshot savecopy area";
        "Shift+Print" = "exec grimshot copy area";
        # tuxedo F1
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        # F2
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        # F3
        "XF86Launch1" = "exec /usr/bin/tuxedo-control-center";
        # F6
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        # F7
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        # F8
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        # F9: display configuration
        "XF86Display" = "exec nwg-displays";
        # F10: play/pause media
        "XF86AudioPlay" = "exec playerctl play-pause";
        # F11: enable/disable Wi-Fi
        "XF86WLAN" = "exec nmcli radio wifi toggle";
        # F12
        "XF86Sleep" = "exec /usr/bin/swaylock";
      };
    };
  };

  xdg.desktopEntries.nwg-displays = {
    name = "Nwg-Displays";
    genericName = "Display Configuration";
    comment = "Configure monitor layout, resolution, scale, and rotation";
    exec = "${pkgs.nwg-displays}/bin/nwg-displays";
    icon = "video-display";
    terminal = false;
    categories = [
      "Settings"
      "HardwareSettings"
    ];
  };
}
