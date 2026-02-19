{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/nix-settings.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/nvidia.nix
    ../../modules/user.nix
    ../../modules/shell.nix
    ../../modules/dev.nix
  ];

  # =================================================================
  # STATE VERSION
  # =================================================================
  system.stateVersion = "25.11";
}
