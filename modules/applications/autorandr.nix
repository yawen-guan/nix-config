# Automatically select a display configuration based on connected devices.

{ config, pkgs, ... }: {
    programs.autorandr.enable = true;
    services.autorandr.enable = true;
}