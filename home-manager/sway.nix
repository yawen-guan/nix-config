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

  # Wrapper for system (apt-installed) sway and swaymsg
  systemSway = pkgs.runCommand "system-sway" { } ''
    mkdir -p "$out/bin"

    cat > "$out/bin/sway" <<'EOF'
    #!/bin/sh
    exec /usr/bin/sway "$@"
    EOF

    cat > "$out/bin/swaymsg" <<'EOF'
    #!/bin/sh
    exec /usr/bin/swaymsg "$@"
    EOF

    chmod +x "$out/bin/sway" "$out/bin/swaymsg"
  '';
in
{
  # Disable home-manager from managing xdg portal and load the system configs.
  # Read https://github.com/nix-community/home-manager/issues/4922#issuecomment-1900844062
  xdg.portal.enable = false;

  home.packages = with pkgs; [
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
  ];

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
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
    elephant.enable = true;
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
        before-sleep = "${pkgs.swaylock}/bin/swaylock";
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
  };

  wayland.systemd.target = "sway-session.target";

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

    # Note that setting `package = null` will disable `extraSessionCommands`.
    # One can print sway PATH by running:
    #   `sway_pid=$(pgrep -xo sway) tr '\0' '\n' < "/proc/$sway_pid/environ" | sed -n 's/^PATH=//p'`
    extraSessionCommands = ''
      export PATH=\"${config.home.profileDirectory}/bin:/nix/var/nix/profiles/default/bin:$PATH\"
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
      # One can print systemd PATH by running:
      #   `systemctl --user show-environment | sed -n 's/^PATH=//p'`
      extraCommands = [
        "systemctl --user set-environment PATH=${config.home.profileDirectory}/bin:/nix/var/nix/profiles/default/bin:$PATH"
        # Default values
        "systemctl --user reset-failed"
        "systemctl --user start sway-session.target"
        "swaymsg -mt subscribe '[]' || true"
        "systemctl --user stop sway-session.target"
      ];
    };

    config = {
      modifier = "Mod4"; # super key
      input = {
        "type:keyboard" = {
          # swap ctrl and caps, use right alt as compose key
          xkb_options = "ctrl:swapcaps,compose:ralt";
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
      bars = [ ]; # Hide the default swaybar.
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
      startup = [
        {
          command = "/usr/bin/swaybg -i ${wallpaper} -m fill";
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
        "Mod4+d" = "exec walker";
        "Mod4+u" = "exec walker --provider windows";
        "Mod4+c" = "exec walker --provider clipboard";
        "Mod4+o" = "exec walker --provider bluetooth";
        "Mod4+Shift+comma" = "move container to output left";
        "Mod4+Shift+period" = "move container to output right";
        "Mod4+Escape" = "exec /usr/bin/swaylock";
        "Mod4+Shift+Escape" = "exec wlogout";
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
