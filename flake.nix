{
  description = "NixOS configuration for 16ITH6H4";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, antigravity-nix, ... }@inputs: {
    nixosConfigurations = {
      "16ITH6H4" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        modules = [
          ./hosts/16ITH6H4/configuration.nix
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };

    # Shell for bootstrapping
    devShells."x86_64-linux".default =
      let
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      in
      pkgs.mkShell {
        packages = with pkgs; [
          git
          just
          nixfmt # Required instead of nixfmt-rfc-style
          nh
          sbctl
          sops
          age
        ];
      };
      
    # Formatter
    formatter."x86_64-linux" = inputs.nixpkgs.legacyPackages."x86_64-linux".nixfmt;
  };
}
