{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  # Imports: hardware-configuration.nix is now imported by flake.nix
  imports = [ ];

  # =================================================================
  # 1. BOOT & SYSTEM SETTINGS
  # =================================================================

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.tpm2.enable = true;

  # Security tools
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  # Networking tweaks
  boot.kernel.sysctl = {
    # TCP Fast Open
    "net.ipv4.tcp_fastopen" = 3;
    # BBR Congestion Control (much faster than default 'cubic')
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  # Nix Settings & Flakes
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;

    # Ensures Nix uses all your CPU cores effectively
    max-jobs = "auto";
    cores = 0; # 0 tells Nix to use all available logical cores

    # Modern efficiency
    compress-build-log = true;
  };

  # 2026 Best Practice: Pin nixpkgs to the flake input
  # This ensures 'nix shell nixpkgs#vim' uses the exact same pkgs as your system
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  nixpkgs.config.allowUnfree = true;

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # ZRAM & Custom Scheduler
  zramSwap.enable = true;

  services.scx = {
    enable = true;
    scheduler = "scx_rusty";
  };

  environment.variables = {
    # Force Wayland for Firefox/Electron apps
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    # NVIDIA VA-API hardware acceleration
    LIBVA_DRIVER_NAME = "nvidia";
  };

  # =================================================================
  # 2. NETWORKING & LOCALES
  # =================================================================

  networking.hostName = "nixos-phukrit";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Bangkok";

  # =================================================================
  # 3. DESKTOP ENVIRONMENT & AUDIO
  # =================================================================

  services.xserver.enable = true;

  # KDE Plasma 6
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Keyboard
  services.xserver.xkb.layout = "us,th";
  services.xserver.xkb.options = "grp:win_space_toggle";

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;
  services.printing.enable = true;

  # =================================================================
  # 4. GRAPHICS & DRIVERS (NVIDIA & iGPU INTEL)
  # =================================================================

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      intel-media-driver # For the Intel iGPU
    ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    # Turing (RTX 20xx) and newer should use open = true
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    powerManagement = {
      enable = true;
      finegrained = true;
    };
  };

  # =================================================================
  # 5. USER CONFIGURATION
  # =================================================================

  programs.starship.enable = true;
  programs.fish = {
    enable = true;
    # Add this block:
    interactiveShellInit = ''
      fnm env --use-on-cd | source
    '';
  };

  users.users.phukrit7171 = {
    isNormalUser = true;
    description = "Phukrit Kittinontana";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "plugdev"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      tree
      brave
      zed-editor
      microsoft-edge
      vscode
      discord-ptb
      google-chrome
      fnm
      uv
    ];
  };

  # =================================================================
  # 6. SYSTEM PACKAGES & TOOLS
  # =================================================================

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    config = {
      user.name = "Mr.Phukrit Kittinontana";
      user.email = "phukrit7171@gmail.com";
      init.defaultBranch = "main";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    helix
    wget
    curl
    git
    grc
    sbctl
    libfido2 # เพิ่มตัวนี้เพื่อใช้คำสั่ง fido2-token
    usbutils # เพิ่มตัวนี้เพื่อใช้คำสั่ง lsusb
    nil
    nixd
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  # =================================================================
  # 7. SERVICES
  # =================================================================

  services.openssh.enable = true;

  # CPU Power Management
  # Since you're using Intel, enable Thermald to prevent thermal throttling
  services.thermald.enable = true;
  # This gives you "Power Save / Balanced / Performance" sliders in your KDE taskbar
  services.power-profiles-daemon.enable = true;

  # Automatically trim SSDs
  services.fstrim.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        AutoEnable = true;
      };
    };
  };

  # Unblock Bluetooth Service
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
  # FIDO2 Optimize
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="4004", MODE="0666", TAG+="uaccess", GROUP="plugdev"
  '';
  # =================================================================
  # 8. STATE VERSION
  # =================================================================

  # Do not change this unless you reinstall.
  system.stateVersion = "25.11";
}
