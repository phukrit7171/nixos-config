{ pkgs, ... }:

{
  home.packages = with pkgs; [
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

    # Utilities
    kdePackages.kcalc
    tree
    htop
    btop
    grc
  ];
}
