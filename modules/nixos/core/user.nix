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
  };

  programs.fish.enable = true;
}
