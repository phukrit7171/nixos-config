{
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    # Default modules
    ../modules/boot.nix
    ../modules/core.nix
    ../modules/desktop.nix
    ../modules/dev.nix
    ../modules/git.nix
    ../modules/nix-settings.nix
    ../modules/nvidia.nix
    ../modules/packages.nix
    ../modules/security.nix
    ../modules/shell.nix
    ../modules/user.nix
    ../modules/containers.nix
  ];

  # =================================================================
  # HOST SPECIFIC CONFIGURATION
  # =================================================================

  networking.hostName = "16ITH6H4";
  time.timeZone = "Asia/Bangkok";

  # Hardware: Lenovo Legion specific
  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
  boot.kernelModules = [ "legion-laptop" ];

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
