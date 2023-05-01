# VSCode settings is synced by the built-in setting-sync.

{ config, pkg, ... }: {
	programs.vscode = {
		enable = true; 
		enableUpdateCheck = true;
	};
}