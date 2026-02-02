{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/nvidia.nix
    ../../modules/user.nix
  ];

  # =================================================================
  # STATE VERSION
  # =================================================================
  system.stateVersion = "25.11";
}
