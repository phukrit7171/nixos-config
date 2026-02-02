{ ... }:

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
  services.printing.enable = true;

  # 2. AUDIO (Pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
