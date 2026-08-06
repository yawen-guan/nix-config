# Yawen's Personal Nix Config

Forked from: https://github.com/Misterio77/nix-starter-configs

## Requirement

Install [nix](https://nixos.org/download/#nix-install-linux).

## On MacOS

The first time: Run the following command to install nix-darwin and build the system.
```bash
sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#[your-hostname]
```

Then we can use darwin-rebuild directly:
```bash
sudo darwin-rebuild switch --flake .#[your-hostname]
```

## On Linux (except NixOS), standalone home-manager

### The first time
Ensure that `nix-command` and `flakes` are enabled:
```bash
# ~/.config/nix/nix.conf
experimental-features = nix-command flakes
```
Run the following command to install home-manager and build the system.
```bash
nix run home-manager -- switch -b backup --flake .#[your-username]@[your-hostname]
```

### Rebuilding
Then we can use home-manger directly:
```bash
home-manager switch --flake .#[your-username]@[your-hostname]
```

Note for `miya@tuxedo`: it needs `--impure` because of `home.file.".local/bin/update-repos-manifest"`.
```bash
home-manager switch --flake .#[your-username]@[your-hostname] --impure
```

## Editing secrets

For example:
```bash
sops ./secrets/tuxedo.yaml
```

## Using sway with `xdg-desktop-portal-gnome`

Check recent xdg-desktop-portal errors:
```bash
journalctl --user -b \
  -u xdg-desktop-portal.service \
  -u xdg-desktop-portal-wlr.service \
  -u xdg-desktop-portal-gtk.service \
  -u xdg-desktop-portal-gnome.service \
  --no-pager -o short-precise --since "500 seconds ago"
```

If there's error `calling StartServiceByName for org.freedesktop.impl.portal.desktop.gnome: Timeout was reached`, according to [comment](https://github.com/flatpak/xdg-desktop-portal/issues/986#issuecomment-1549698643), one walkaround is to switch the system dbus implementation to dbus-broker, by running the following commands:

```bash
sudo apt install dbus-broker
sudo systemctl enable --global dbus-broker.service
sudo systemctl enable dbus-broker.service
```

## Zoom screen sharing in Wayland

Make sure that `xdg-desktop-portal-wlr` is installed and running:
```bash
sudo apt install xdg-desktop-portal-wlr
systemctl --user status xdg-desktop-portal-wlr.service
```

Install `zoom` using the official deb, see https://zoom.us/download.

Note that only desktop capture is supported, window capture is not supported.
