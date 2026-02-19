{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.modules.features.nvidia = {
    enable = lib.mkEnableOption "Nvidia Graphics Support";
    intelBusId = lib.mkOption {
      type = lib.types.str;
      description = "Bus ID of the Intel GPU";
    };
    nvidiaBusId = lib.mkOption {
      type = lib.types.str;
      description = "Bus ID of the Nvidia GPU";
    };
  };

  config = lib.mkIf config.modules.features.nvidia.enable {
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
        intelBusId = config.modules.features.nvidia.intelBusId;
        nvidiaBusId = config.modules.features.nvidia.nvidiaBusId;
      };
    };
  };
}
