# zsh is set to be the default shell using `chsh`. 

{ config, lib, pkgs, ... }: {
    programs.zsh = {
        enable = true;

        # Extra commands for .zshrc file.
        initExtra = ''
            export PATH="$PATH:/home/yawen/.config/emacs/bin" # doom emacs
            export PATH="$PATH:/home/yawen/.local/bin"
            export PATH="$PATH:/usr/local/texlive/2023/bin/x86_64-linux"
            export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
            export LC_ALL=en_US.UTF-8
            # opam
            [[ ! -r /home/yawen/.opam/opam-init/init.zsh ]] || source /home/yawen/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
            # ghci
            export PATH="/home/yawen/.ghcup/bin:$PATH"
        '';

        oh-my-zsh = {
            enable = true;
            custom = "$HOME/.config/oh-my-zsh-custom";
            plugins = [ 
                "git"
                "command-not-found" 
            ];
            theme = "lambda-mod";
        };

        plugins = [
            {
                name = "zsh-nix-shell";
                file = "nix-shell.plugin.zsh";
                src = pkgs.fetchFromGitHub {
                    owner = "chisui";
                    repo = "zsh-nix-shell";
                    rev = "v0.5.0";
                    sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
                };
            }
            {
                name = "zsh-autosuggestions";
                src = "${pkgs.zsh-autosuggestions}";
                file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
            }
            {
                name = "zsh-syntax-highlighting";
                src = "${pkgs.zsh-syntax-highlighting}";
                file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
            }
            {
                name = "zsh-you-should-use";
                src = "${pkgs.zsh-you-should-use}";
                file = "share/zsh-you-should-use/zsh-you-should-use.zsh";
            }
            # {
            #     name = "agkozak-zsh-prompt";
            #     src = pkgs.fetchFromGitHub {
            #         owner = "agkozak";
            #         repo = "agkozak-zsh-prompt";
            #         rev = "v3.11.1";
            #         sha256 = "1rl0bqmflz7c1n6j6n4677x6kscc160s6zd5his8bf1m3idw1rsc";
            #     };
            #     file = "agkozak-zsh-prompt.plugin.zsh";
            # }
        ];
    };
}
