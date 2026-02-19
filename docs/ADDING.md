# Adding a New Host

1. Create `hosts/<hostname>/configuration.nix`:
   ```nix
   { inputs, pkgs, config, lib, ... }:
   {
     imports = [
       ./hardware-configuration.nix
       ../../modules/nixos/core/default.nix
       ../../modules/nixos/core/security.nix
       ../../modules/nixos/features
       inputs.home-manager.nixosModules.home-manager
     ];

     modules.core.boot.enable = true;
     modules.core.system.enable = true;
     modules.core.nix.enable = true;
     modules.core.user.enable = true;

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
   nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
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

1. Create `modules/nixos/<category>/<name>.nix`:
   ```nix
   { pkgs, config, lib, ... }:
   {
     options.modules.<category>.<name>.enable =
       lib.mkEnableOption "<Description>";

     config = lib.mkIf config.modules.<category>.<name>.enable {
       # Your configuration here
     };
   }
   ```

2. Import in the corresponding `default.nix`.

3. Enable in `configuration.nix`:
   ```nix
   modules.<category>.<name>.enable = true;
   ```

# Adding Home Manager Programs

Add a new file under `home/phukrit7171/core/` and import it in `home/phukrit7171/default.nix`.

Example `home/phukrit7171/core/neovim.nix`:
```nix
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
```

Then add `./core/neovim.nix` to the imports list in `default.nix`.
