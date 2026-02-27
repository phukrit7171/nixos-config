{ pkgs, inputs, ... }:

{
  # System-wide packages to replace the home-manager managed packages
  environment.systemPackages = with pkgs; [
    # Credentials
    kdePackages.ksshaskpass

    # Office
    libreoffice-fresh

    # Browsers
    brave
    google-chrome

    # Communication & Media
    spotify
    vesktop

    # Editors & Dev
    zed-editor
    fnm
    uv
    dbeaver-bin
    thonny
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-no-fhs
    git-credential-manager

    # Utilities
    kdePackages.kcalc
    tree
    htop
    btop
    grc
  ];
}
