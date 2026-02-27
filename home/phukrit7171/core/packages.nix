{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.ksshaskpass
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
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    git-credential-manager
    # Utilities
    kdePackages.kcalc
    tree
    htop
    btop
    grc
  ];
}
