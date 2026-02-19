{ pkgs, ... }:

{
  # NETWORKING & TIME
  networking.hostName = "nixos-phukrit";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Bangkok";

  # VPN Netbird
  services.netbird.enable = true;
  environment.systemPackages = with pkgs; [ netbird-ui ];

  # SYSTEM SERVICES
  zramSwap.enable = true;
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [ "--autopower" ];
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

  # BLUETOOTH UNBLOCK HACK (Lenovo Legion)
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

  # UDEV RULES (FIDO2)
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="4004", MODE="0666", TAG+="uaccess", GROUP="plugdev"
  '';
}
