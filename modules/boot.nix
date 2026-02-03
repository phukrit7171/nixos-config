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

  # KERNEL TWEAKS
  boot.kernelPackages = pkgs.linuxPackages_latest.extend (
    self: super: {
      kernel =
        (super.kernel.override {
          # 1. ใช้ LLVM Toolchain แทน GCC stdenv
          stdenv = pkgs.llvmPackages_latest.stdenv;

          # 2. ตั้งค่าโครงสร้าง Kconfig ให้ถูกต้อง (ต้องอยู่ใน override)
          structuredConfig = with pkgs.lib.kernel; {
            LTO_NONE = no;
            LTO_CLANG_FULL = yes;
            CC_OPTIMIZE_FOR_PERFORMANCE = yes;
            CC_OPTIMIZE_FOR_SIZE = no;
            PREEMPT_VOLUNTARY = yes;
          };
        }).overrideAttrs
          (oldAttrs: {
            # 3. ใส่ Flags การคอมไพล์ที่ต้องการ
            NIX_CFLAGS_COMPILE = (oldAttrs.NIX_CFLAGS_COMPILE or [ ]) ++ [
              "-O3"
              "-march=native"
              "-flto=full"
              "-pipe"
              "-fno-plt"
            ];

            # 4. บังคับใช้ LLVM Toolchain ทั้งระบบการ Build ของ Kernel
            # LLVM=1 จะสั่งให้ใช้ clang, lld, llvm-ar, llvm-nm แทน GNU binutils
            makeFlags = (oldAttrs.makeFlags or [ ]) ++ [
              "LLVM=1"
              "LLVM_IAS=1"
              "LD=ld.lld"
            ];

            # ดึง llvm มาช่วยช่วง Linking (สำหรับ lld)
            nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
              pkgs.llvmPackages_latest.llvm
              pkgs.llvmPackages_latest.lld
            ];
          });
    }
  );

  boot.kernel.sysctl = {
    "net.ipv4.tcp_fastopen" = 3;
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  # This pulls the specific driver for Legion 5 Pro (16ITH6H)
  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];

  # Load the module at boot
  boot.kernelModules = [ "lenovo-legion-module" ];
}
