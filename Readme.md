# Yawen's Personal Nix Config

Forked from: https://github.com/Misterio77/nix-starter-configs

## Requirement

Install [nix](https://nixos.org/download/#nix-install-linux).

## On MacOS

The first time: Run the following command to install nix-darwin and build the system.
```bash
sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#[your-hostname]
```

Then we can use darwin-rebuild directly: 
```bash
sudo darwin-rebuild switch --flake .#[your-hostname]
```

## On Linux (except NixOS), standalone home-manager

The first time: Run the following command to install home-manager and build the system. 
```bash
nix run home-manager -- switch -b backup --flake .#[your-username]@[your-hostname]
```

Then we can use home-manger directly: 
```bash
home-manager switch --flake .#[your-username]@[your-hostname]
```

Note for `miya@tuxedo`: it needs `--impure` because of `home.file.".local/bin/update-repos-manifest"`.
```bash
home-manager switch --flake .#[your-username]@[your-hostname] --impure
```
