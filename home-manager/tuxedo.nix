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
    sopsModules = inputs.sops-nix.homeManagerModules.sops;
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
  targets.genericLinux.nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
    # offloadWrapper = "nvidiaPrime";
    installScripts = [
      "mesa"
      # "nvidiaPrime"
    ];
  };

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

    restic

    # ===== apt-installed packages =====
    # zoom-us # https://zoom.us/download

    # ===== other packages =====
    # (config.lib.nixGL.wrap unstable.steam)
  ];

  home.file.".local/bin/update-repos-manifest" = {
    source = ../scripts/update-repos-manifest.sh;
    executable = true;
  };

  # Read: https://michael.stapelberg.ch/posts/2025-08-24-secret-management-with-sops-nix/
  sops = {
    # I derived the age private key from my ssh key using
    #   ssh-to-age -private-key -i <ssh-private-key-path> -o <age-private-key-path>
    # To display the age recipient (public key) of this age identity (private key), use:
    #   age-keygen -y <age-private-key-path>
    # I stored this public key in .sops.yaml
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    # To edit the secrets, run:
    #   sops <secret-yaml-file>
    # This command will decrypt the file using the private key, open it in an editor,
    # and encrypt it again once closed.
    defaultSopsFile = ../secrets/tuxedo.yaml;
    secrets = {
      resticDiskRepo.key = "resticDiskRepo";
      resticDiskPassword.key = "resticDiskPassword";
      resticRemoteRepo.key = "resticRemoteRepo";
      resticRemotePassword.key = "resticRemotePassword";
    };
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

  services = {
    restic = {
      enable = true;
      backups =
        let
          backupPaths = [
            "${config.home.homeDirectory}/.config"
            "${config.home.homeDirectory}/.ssh"
            "${config.home.homeDirectory}/Desktops"
            "${config.home.homeDirectory}/Documents"
            "${config.home.homeDirectory}/Downloads"
            "${config.home.homeDirectory}/Pictures"
            "${config.home.homeDirectory}/Repos"
            "${config.home.homeDirectory}/Sync"
            "${config.home.homeDirectory}/Videos"
            "${config.home.homeDirectory}/VMs"
            "${config.home.homeDirectory}/Zotero"
          ];
          backupExclude = [
            "**/.cache"
            "**/.direnv"
          ];
          pruneOpts = [
            "--keep-daily 7"
            "--keep-weekly 4"
            "--keep-monthly 12"
          ];
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
          };
        in
        {
          dailyDisk = {
            # To check the service, run `systemctl --user status restic-backups-dailyDisk.service`
            repository = config.sops.secrets.resticDiskRepo.path;
            passwordFile = config.sops.secrets.resticDiskPassword.path;
            paths = backupPaths;
            exclude = backupExclude;
            initialize = true;
            timerConfig = timerConfig;
            pruneOpts = pruneOpts;
            runCheck = true;
          };
          dailyRemote = {
            repository = config.sops.secrets.resticRemoteRepo.path;
            passwordFile = config.sops.secrets.resticRemotePassword.path;
            paths = backupPaths;
            exclude = backupExclude;
            initialize = true;
            timerConfig = timerConfig;
            pruneOpts = pruneOpts;
            runCheck = true;
          };
        };
    };
  };
}
