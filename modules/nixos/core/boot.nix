{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.modules.core.boot.enable = lib.mkEnableOption "Core Boot Configuration";

  config = lib.mkIf config.modules.core.boot.enable {
    # BOOTLOADER
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.loader.efi.canTouchEfiVariables = true;

    # TPM & SECURE BOOT SUPPORT
    boot.initrd.systemd.enable = true;
    boot.initrd.systemd.tpm2.enable = true;
    security.tpm2.enable = true;
    security.tpm2.pkcs11.enable = true;
    security.tpm2.tctiEnvironment.enable = true;

    # LANZABOOTE (Secure Boot)
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # KERNEL
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # SYSCTL TWEAKS
    boot.kernel.sysctl = {
      "net.ipv4.tcp_fastopen" = 3;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "vm.swappiness" = 100;
    };
  };
}
