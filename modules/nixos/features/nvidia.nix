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
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    powerManagement = {
      enable = true;
      finegrained = false;
    };

    # Prime Offload (Switching between Intel/Nvidia)
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

}
