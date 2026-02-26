{
  description = "NixOS configuration for 16ITH6H4";

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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      treefmt-nix,
      sops-nix,
      antigravity-nix,
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
            "16ITH6H4" = self.nixosConfigurations."16ITH6H4".config.system.build.toplevel;
          };
        };

      flake = {
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
      };
    };
}
