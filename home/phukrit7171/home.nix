{ pkgs, ... }:

{
  home.username = "phukrit7171";
  home.homeDirectory = "/home/phukrit7171";
  home.stateVersion = "25.11";

  # --- User Packages ---
  home.packages = with pkgs; [
    # Browsers
    brave
    microsoft-edge
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

  # --- Shell ---
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fnm env --use-on-cd | source
    '';
  };

  programs.starship.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # --- Git ---
  programs.git = {
    enable = true;
    settings = {
      user.name = "Mr.Phukrit Kittinontana";
      user.email = "phukrit7171@gmail.com";
      init.defaultBranch = "main";
    };
  };

  # --- Firefox ---
  programs.firefox.enable = true;

  # Let HM manage itself
  programs.home-manager.enable = true;
}
