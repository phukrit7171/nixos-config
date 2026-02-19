{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/core/boot.nix
    ../../modules/nixos/core/nix-settings.nix
    ../../modules/nixos/core/core.nix
    ../../modules/nixos/features/desktop.nix
    ../../modules/nixos/features/nvidia.nix
    ../../modules/nixos/core/user.nix
    ../../modules/nixos/features/dev.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.phukrit7171 = import ../../home/phukrit7171/home.nix;
    extraSpecialArgs = { inherit inputs; };
  };

  # =================================================================
  # STATE VERSION
  # =================================================================
  system.stateVersion = "25.11";
}
