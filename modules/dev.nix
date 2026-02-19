{ pkgs, ... }:

{
  # --- Editors & Dev Tools ---
  environment.systemPackages = with pkgs; [
    # Editors
    vim
    neovim
    helix
    vscode
    zed-editor
    antigravity

    # Build tools
    pkg-config
    gnumake
    gcc

    # Nix tooling
    nil
    nixfmt
    nixd
  ];

  # --- Version Control ---
  programs.git = {
    enable = true;
    config = {
      user.name = "Mr.Phukrit Kittinontana";
      user.email = "phukrit7171@gmail.com";
      init.defaultBranch = "main";
    };
  };

  # --- Language Toolchains (user-scoped) ---
  users.users.phukrit7171.packages = with pkgs; [
    fnm # Node version manager
    uv # Python package manager
    dbeaver-bin # Database GUI
  ];

  # --- nix-ld (Run unpatched binaries) ---
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Core
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat

    # LLVM / Clang
    libclang.lib
    clang

    # System libraries
    glib
    libuuid
    libusb1
    libsecret
    libnotify
    libcap
    systemd
    dbus
    at-spi2-atk

    # Graphics & UI
    fontconfig
    freetype
    libGL
    libGLU
    xorg.libX11
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXrandr
  ];
}
