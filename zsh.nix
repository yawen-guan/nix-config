{ config, lib, pkgs, ... }:

{
    programs.zsh = {
        enable = true;
        oh-my-zsh = {
            enable = true;
            plugins = [ 
                "git"
                "command-not-found" 
            ];
            theme = "robbyrussell";
        };
        plugins = [
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
            {
                name = "agkozak-zsh-prompt";
                src = pkgs.fetchFromGitHub {
                    owner = "agkozak";
                    repo = "agkozak-zsh-prompt";
                    rev = "v3.11.1";
                    sha256 = "1rl0bqmflz7c1n6j6n4677x6kscc160s6zd5his8bf1m3idw1rsc";
                };
                file = "agkozak-zsh-prompt.plugin.zsh";
            }
        ];
    };
}