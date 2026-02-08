{
  description = "NixOS configuration for nixos-phukrit";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        nixos-phukrit = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          # 1. Close specialArgs here
          specialArgs = { inherit inputs; };

          # 2. modules is now a separate argument
          modules = [
            ./hosts/nixos-phukrit/configuration.nix
          ];
        };
      };
    };
}
