{
  imports = [
    ./core/shell.nix
    ./core/git.nix
    ./core/packages.nix
  ];

  home.username = "phukrit7171";
  home.homeDirectory = "/home/phukrit7171";
  home.stateVersion = "25.11";

  # Let HM manage itself
  programs.home-manager.enable = true;

  # Firefox
  programs.firefox.enable = true;
}
