{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Browsers
    brave

    google-chrome
    kdePackages.falkon

    # Communication & Media
    spotify
    vesktop

    # Editors & Dev
    vscode
    zed-editor
    antigravity
    fnm
    uv
    dbeaver-bin

    # Utilities
    kdePackages.kcalc
    tree
    htop
    btop
    grc
  ];
}
