# Home-manager configuration file for infinitybook.
# (It replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  common-all = import ./common/all.nix {
    inherit lib config pkgs;
    homeManagerModules = outputs.homeManagerModules;
    overlays = outputs.overlays;
  };
in
{
  imports = [
    common-all
    ./common/linux.nix
  ];

  # NixGL Integration.
  # Read: https://nix-community.github.io/home-manager/index.xhtml#sec-usage-gpu-non-nixos
  # Set primary GPU wrapper as mesa, and secondary GPU wrapper as nvidiaPrime
  # ("Prime" means it is for secondary GPU). Later, Call `config.lib.nixGL.wrap`
  # for programs using the primary GPU, and `config.lib.nixGL.wrapOffload` for
  # programs using the secondary GPU.
  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = [
    "mesa"
    "nvidiaPrime"
  ];

  home = {
    username = "miya";
    homeDirectory = "/home/miya";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
  };

  # More packages.
  home.packages = with pkgs; [
    (config.lib.nixGL.wrap spotify)
    (config.lib.nixGL.wrap telegram-desktop)
    (config.lib.nixGL.wrap typora)

    # ===== apt-installed packages =====
    # zoom-us # https://zoom.us/download

    # ===== other packages =====
    # (config.lib.nixGL.wrap unstable.steam)
  ];

  home.file.".local/bin/update-repos-manifest" = {
    source = ../scripts/update-repos-manifest.sh;
    executable = true;
  };

  # Manually run the service: `systemctl --user start update-repos-manifest.service`
  systemd.user.services.update-repos-manifest = {
    Unit = {
      Description = "Update repos manifest";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.local/bin/update-repos-manifest";
    };
  };

  # Check the timer status: `systemctl --user status update-repos-yaml.timer`
  systemd.user.timers.update-repos-manifest = {
    Unit = {
      Description = "Run update-repos-manifest daily";
    };
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
