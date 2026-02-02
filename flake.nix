{
  description = "NixOS configuration for nixos-phukrit";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        nixos-phukrit = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            modules = [
              ./hosts/nixos-phukrit/configuration.nix
            ];
          };
        };
      };
    };
}
