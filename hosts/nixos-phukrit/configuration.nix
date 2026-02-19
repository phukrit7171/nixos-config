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
    ../../modules/nixos/core/default.nix
    ../../modules/nixos/core/security.nix
    ../../modules/nixos/features
    inputs.home-manager.nixosModules.home-manager
  ];

  # =================================================================
  # SYSTEM COMPOSITION (Enable Modules)
  # =================================================================

  # Core System
  modules.core.boot.enable = true;
  modules.core.system.enable = true;
  modules.core.nix.enable = true;
  modules.core.user.enable = true;
  modules.core.security.enable = true;

  # Features
  modules.features.desktop.enable = true;
  modules.features.desktop.printing.enable = true;
  modules.features.desktop.scanning.enable = true;
  modules.features.nvidia = {
    enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  modules.features.dev.enable = true;

  # =================================================================
  # HOST SPECIFIC CONFIGURATION
  # =================================================================

  networking.hostName = "nixos-phukrit";
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

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.phukrit7171 = {
      imports = [
        ../../home/phukrit7171/default.nix
      ];
    };
    extraSpecialArgs = { inherit inputs; };
  };

  # =================================================================
  # STATE VERSION
  # =================================================================
  system.stateVersion = "25.11";
}
