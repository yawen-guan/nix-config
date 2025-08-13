{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [ ];

  home.packages = with pkgs; [
    # ===== Utils =====
    # crow-translate
    # timeshift-minimal
    ttfautohint
    rsnapshot
  ];

  programs = {
    kitty.package = (config.lib.nixGL.wrap pkgs.kitty);
    emacs = {
      enable = true;
    };
    vscode = {
      enable = true;
      enableUpdateCheck = false;
      extensions = (with pkgs.vscode-extensions; [
        bbenoist.nix
        vscodevim.vim
      ]);
      userSettings = {
        "workbench.colorTheme" = "Quiet Light";
        "vim.insertModeKeyBindings" = [
            { # Exit insert mode with "jk"
                "before" = ["j" "k"];
                "after" = ["<Esc>"];
            }
        ];
      };
    };
  };

  # Make installed apps show up in Gnome.
  # Read: https://github.com/nix-community/home-manager/issues/1439
  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
