{ config, pkgs, ... }: {
  programs.bash = {
    enable = true;
    profileExtra = ''
                  # Help application launcher find nix installed applications.
                  export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS" 
                  export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
                  export TERMINAL="kitty"
      	        export PATH="$PATH:/usr/local/texlive/2023/bin/x86_64-linux"
    '';
    initExtra = ''
      export LC_ALL=en_US.UTF-8
    '';
  };
}
