{
  description = "NixOS configuration for nixos-phukrit";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          # Formatting
          treefmt.projectRootFile = "flake.nix";
          treefmt.programs.nixfmt.enable = true; # nixfmt-rfc-style

          # Shell for bootstrapping
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              git
              just
              nixfmt
              nh
              sbctl
              sops
              age
            ];
          };

          # Checks
          checks = {
            # Build the configuration to verify it works
            nixos-phukrit = self.nixosConfigurations.nixos-phukrit.config.system.build.toplevel;
          };
        };

      flake = {
        nixosConfigurations = {
          nixos-phukrit = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs self; };
            modules = [
              ./hosts/nixos-phukrit/configuration.nix
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.sops-nix.nixosModules.sops
            ];
          };
        };
      };
    };
}
