{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Browsers
    brave
    # microsoft-edge # 404 error
    google-chrome
    kdePackages.falkon

    # Communication & Media
    spotify
    vesktop

    # Editors & Dev
    vscode
    zed-editor
    # antigravity # Assuming this is available or custom
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
