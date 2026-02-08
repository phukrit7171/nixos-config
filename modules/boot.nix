{ config, pkgs, ... }:

{
  # BOOTLOADER
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # TPM & SECURE BOOT SUPPORT
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.tpm2.enable = true;
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  # KERNEL
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # SYSCTL TWEAKS (Keep these, they are high impact/low risk)
  boot.kernel.sysctl = {
    "net.ipv4.tcp_fastopen" = 3;
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    # Improve OOM handling and swap snappiness
    "vm.swappiness" = 10;
  };

  # HARDWARE SPECIFIC
  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
  boot.kernelModules = [ "lenovo-legion-module" ];
}
