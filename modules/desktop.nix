{ pkgs, ... }:

{
  # 1. DESKTOP ENVIRONMENT
  services.xserver.enable = true;

  # Display Manager (SDDM)
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Desktop (KDE Plasma 6)
  services.desktopManager.plasma6.enable = true;

  # Input
  services.libinput.enable = true;
  services.xserver.xkb.layout = "us,th";
  services.xserver.xkb.options = "grp:win_space_toggle";

  # 2. AUDIO (Pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ]; # General Brother laser/inkjet driver
  };

  # Enable network discovery for the printer (Avahi/mDNS)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Optional: Scanner support for the T520W
  hardware.sane = {
    enable = true;
    extraBackends = [
      pkgs.brscan5
      pkgs.sane-airscan
    ];
    brscan5.netDevices = {
      home = {
        model = "DCP-T520W";
        ip = "192.168.1.104";
      };
    };
  };

  environment.systemPackages = [ pkgs.kdePackages.skanpage ];

  hardware.printers.ensurePrinters = [
    {
      name = "Brother_DCP_T520W";
      deviceUri = "ipp://192.168.1.104/ipp";
      model = "everywhere";
      description = "Brother DCP-T520W via IPP Everywhere";
    }
  ];
  services.udev.packages = [ pkgs.brscan5 ];
}
