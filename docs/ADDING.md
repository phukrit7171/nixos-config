# Adding a New Host

1. Create `hosts/<hostname>/configuration.nix`:
   ```nix
   { inputs, pkgs, config, lib, ... }:
   {
     imports = [
       ./hardware-configuration.nix
       
       # Import modules you want natively
       ../../modules/nixos/core/boot.nix
       ../../modules/nixos/core/core.nix
       ../../modules/nixos/core/user.nix
       ../../modules/nixos/features/desktop.nix
     ];

     networking.hostName = "<hostname>";
     system.stateVersion = "25.11";
   }
   ```

2. Generate hardware config:
   ```bash
   nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
   ```

3. Add to `flake.nix`:
   ```nix
   nixosConfigurations."<hostname>" = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     specialArgs = { inherit inputs self; };
     modules = [
       ./hosts/<hostname>/configuration.nix
       inputs.sops-nix.nixosModules.sops
     ];
   };
   ```

4. Build: `sudo nixos-rebuild switch --flake .#<hostname>`

# Adding a New Module

This setup uses an extremely simple module structure without abstract toggles.

1. Create `modules/nixos/<category>/<name>.nix`:
   ```nix
   { pkgs, config, ... }:
   {
     # Your system-wide configuration here
     environment.systemPackages = [ pkgs.neovim ];
   }
   ```

2. Enable the module by simply adding it to the `imports = []` array in your `hosts/<hostname>/configuration.nix`:
   ```nix
   imports = [
     # ...
     ../../modules/nixos/<category>/<name>.nix
   ];
   ```
