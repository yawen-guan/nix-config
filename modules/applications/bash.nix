{ config, pkgs, ... }: {
    programs.bash = {
        enable = true;
        profileExtra = ''
            # Help application launcher find nix installed applications.
            export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS" 

            export TERMINAL="kitty"
        '';
        initExtra = ''
            export LC_ALL=en_US.UTF-8
        '';
    };
}