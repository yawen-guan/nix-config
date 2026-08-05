{
  config,
  lib,
  pkgs,
  ...
}:

let
  wallpaper = "${config.home.homeDirectory}/Pictures/wallpapers/jellyfish.jpg";
in
{
  home.packages = with pkgs; [
    wdisplays

    # used by waybar
    pavucontrol
    peaclock
    playerctl

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
      systemd.enable = true;
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

  wayland.windowManager.sway = {
    enable = true;
    package = null; # use /usr/bin/sway instead
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
          xkb_options = "ctrl:swapcaps"; # swap ctrl and caps
        };
      };
      output = {
        "California Institute of Technology 0x1402 Unknown" = {
          scale = "2";
          mode = "2880x1800@90Hz";
        };
        "LG Electronics LG ULTRAFINE 211MADHQ5B34" = {
          scale = "2";
          mode = "3840x2160@60Hz";
        };
      };
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
        "Mod4+Escape" = "exec /usr/bin/swaylock";
        "Mod4+Shift+Escape" = "exec wlogout";
        "Print" = "exec grimshot savecopy area";
        "Shift+Print" = "exec grimshot copy area";
      };
    };
  };

}
