# VSCode settings is synced by the built-in setting-sync.

{ config, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = true;
    package = pkgs.vscode;
  };
}
