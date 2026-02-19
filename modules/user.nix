{ pkgs, ... }:

{
  users.users.phukrit7171 = {
    isNormalUser = true;
    description = "Phukrit Kittinontana";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "plugdev"
      "scanner"
      "lpadmin"
      "lp"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      # Browsers
      brave
      microsoft-edge
      google-chrome
      kdePackages.falkon

      # Communication & Media
      spotify
      vesktop

      # Utilities
      kdePackages.kcalc
    ];
  };

  programs.firefox.enable = true;
}
