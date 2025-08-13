# Configuration for zsh.
# Note:
# - zsh is set to be the default shell using `chsh`.

{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;

    # Extra commands for .zshrc file.
    initContent = ''
      # doom emacs
      export PATH="$PATH:$HOME/.config/emacs/bin" # doom emacs
      # fix locale
      # read: https://stackoverflow.com/questions/2499794/how-to-fix-a-locale-setting-warning-from-perl
      LC_CTYPE=en_US.UTF-8
      LC_ALL=en_US.UTF-8
      # zsh auto-suggestion text color
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'
      # pyenv
      export PYENV_ROOT="$HOME/.pyenv"
      [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"
      # opam
      [[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
    '';

    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.config/oh-my-zsh-custom";
      plugins = [
        "git"
        "command-not-found"
        "fzf"
      ];
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
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];
  };
}
