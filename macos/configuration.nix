# MacOS's System Configuration
{ pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = (with pkgs; [ vim ]);

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];

  fonts.packages = with pkgs; [
    iosevka
    nerd-fonts.noto
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    libertinus
  ];

  system = {
    # Set Git commit hash for darwin-version.
    # configurationRevision = self.rev or self.dirtyRev or null;

    primaryUser = "yawen";

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;

    defaults = {
      # customize settings that not supported by nix-darwin directly
      # Incomplete list of macOS `defaults` commands :
      #   https://github.com/yannbertrand/macos-defaults
      NSGlobalDomain = {
        # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
        # This is very useful for vim users, they use `hjkl` to move cursor.
        # sets how long it takes before it starts repeating.
        InitialKeyRepeat = 15; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
        # sets how fast it repeats once it starts.
        KeyRepeat = 2; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)
      };

      # customize dock
      dock = {
        autohide = true;
        show-recents = true; # show recent apps
      };
    };
  };

  services = {
    emacs.enable = true;
    # Replaced by amethyst.
    # Read: https://github.com/heywoodlh/nixos-builds/blob/master/darwin/wm.nix
    #   yabai = {
    #     enable = true;
    #     package = pkgs.yabai;
    #     enableScriptingAddition = false;
    #     extraConfig = ''
    #       yabai -m config layout floating
    #     '';
    #   };
    #   skhd = {
    #     enable = true;
    #     package = pkgs.skhd;
    #     skhdConfig = ''
    #       # make floating window fill screen
    #       ctrl + shift - i : yabai -m window --grid 1:1:0:0:1:1 # the entire screen
    #       ctrl + shift - h : yabai -m window --grid 1:2:0:0:1:1 # left half
    #       ctrl + shift - l : yabai -m window --grid 1:2:1:0:1:1 # right half
    #       ctrl + shift - 9 : yabai -m window --grid 1:3:0:0:1:1 # left one-third
    #       ctrl + shift - 0 : yabai -m window --grid 1:3:1:0:2:1 # right two-third
    #     '';
    #   };
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = false;
    casks = [
      "amethyst"
      "spotify"
    ];
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
}
