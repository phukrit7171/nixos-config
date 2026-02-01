{
  description = "NixOS configuration for nixos-phukrit";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ...  }@inputs: {
    nixosConfigurations = {
      # Hostname: nixos-phukrit
      nixos-phukrit = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Pass 'inputs' to all modules so you can use them there
        specialArgs = { inherit inputs; };

        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix
        ];
      };
    };
  };
}
