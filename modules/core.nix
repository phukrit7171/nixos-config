{
  pkgs,
  inputs,
  ...
}:

{
  # 1. BOOT & TPM
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Silent Boot / TPM
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.tpm2.enable = true;
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  # 2. NETWORKING & KERNEL TWEAKS
  networking.hostName = "nixos-phukrit";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Bangkok";

  boot.kernel.sysctl = {
    "net.ipv4.tcp_fastopen" = 3;
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  # 3. NIX SETTINGS
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    max-jobs = "auto";
    cores = 0;
    compress-build-log = true;
  };

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Pin nixpkgs to flake input
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nixpkgs.config.allowUnfree = true;

  # 4. SYSTEM SERVICES (Bluetooth, Power, Scheduler)
  zramSwap.enable = true;
  services.scx = {
    enable = true;
    scheduler = "scx_rusty";
  };

  services.openssh.enable = true;
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;
  services.fstrim.enable = true;

  # Bluetooth & Fixes
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
      AutoEnable = true;
    };
  };

  # Bluetooth Unblock Hack
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

  # FIDO2 Rules
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="4004", MODE="0666", TAG+="uaccess", GROUP="plugdev"
  '';
}
