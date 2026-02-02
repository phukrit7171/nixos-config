{ config, pkgs, ... }:

{
  # 1. GRAPHICS SETTINGS
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      intel-media-driver
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # 2. NVIDIA DRIVER CONFIG
  hardware.nvidia = {
    modesetting.enable = true;
    open = true; # [cite_start]RTX 20xx+ uses open kernel modules [cite: 28]
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    # Prime Offload (Switching between Intel/Nvidia)
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # 3. ENVIRONMENT VARIABLES
  environment.variables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
  };
}
