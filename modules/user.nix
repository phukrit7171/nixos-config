{ pkgs, ... }:

{
  users.users.phukrit7171 = {
    isNormalUser = true;
    description = "Phukrit Kittinontana";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "scanner"
      "lpadmin"
      "lp"
      "podman"
    ];
    shell = pkgs.fish;
  };
}
