{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    # Core
    ../../modules/nixos/core/boot.nix
    ../../modules/nixos/core/core.nix
    ../../modules/nixos/core/nix-settings.nix
    ../../modules/nixos/core/security.nix
    ../../modules/nixos/core/user.nix
    ../../modules/nixos/core/packages.nix
    ../../modules/nixos/core/git.nix
    ../../modules/nixos/core/shell.nix

    # Features
    ../../modules/nixos/features/desktop.nix
    ../../modules/nixos/features/dev.nix
    ../../modules/nixos/features/nvidia.nix
  ];

  # =================================================================
  # HOST SPECIFIC CONFIGURATION
  # =================================================================

  networking.hostName = "16ITH6H4";
  time.timeZone = "Asia/Bangkok";

  # Hardware: Lenovo Legion specific
  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
  boot.kernelModules = [ "lenovo-legion-module" ];

  # Bluetooth Unblock Hack (Lenovo Legion)
  systemd.services.unblock-bluetooth = {
    description = "Unblock Bluetooth on Lenovo Legion";
    wantedBy = [ "multi-user.target" ];
    after = [ "bluetooth.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      RemainAfterExit = true;
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # =================================================================
  # STATE VERSION
  # =================================================================
  system.stateVersion = "25.11";
}
