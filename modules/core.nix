{ pkgs, ... }:

{
  # NETWORKING & TIME
  networking.networkmanager.enable = true;
  # time.timeZone handled by host config or default

  # VPN Netbird
  services.netbird.enable = true;
  environment.systemPackages = with pkgs; [ netbird-ui ];

  # SYSTEM SERVICES
  zramSwap.enable = true;
  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
  };

  services.openssh.enable = true;
  services.power-profiles-daemon.enable = true;
  services.fstrim.enable = true;

  # BLUETOOTH
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
      AutoEnable = true;
    };
  };
}
