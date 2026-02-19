# 🏗️ NixOS Configuration — nixos-phukrit

Declarative NixOS configuration for a **Lenovo Legion** laptop, built with **Flakes** and **flake-parts**.

## ✨ Features

| Feature | Details |
|---|---|
| **Flakes** | Fully reproducible with `flake.lock` |
| **Modular Design** | System split into `core` and `features` modules |
| **Home Manager** | User config split into `shell`, `git`, `packages` |
| **KDE Plasma 6** | Wayland + SDDM |
| **Nvidia Prime** | Sync mode (Intel + Nvidia) |
| **BTRFS** | `compress=zstd`, `noatime`, `discard=async` |
| **Zram** | `swappiness=100` for optimal compression |
| **LUKS + TPM2** | Full disk encryption with auto-unlock |
| **sops-nix** | Secrets management (ready to configure) |
| **scx_lavd** | eBPF scheduler for improved responsiveness |
| **treefmt** | Automated formatting with `nixfmt` |

## 📁 Structure

```
nixos-config/
├── flake.nix                         # Entry point (inputs & outputs)
├── flake.lock                        # Pinned dependencies
│
├── hosts/
│   └── nixos-phukrit/
│       ├── configuration.nix         # Host-specific config & module composition
│       └── hardware-configuration.nix # Hardware & BTRFS mounts
│
├── modules/nixos/
│   ├── core/
│   │   ├── default.nix               # Imports all core modules
│   │   ├── boot.nix                  # Bootloader, kernel, sysctl
│   │   ├── core.nix                  # Networking, Bluetooth, services
│   │   ├── nix-settings.nix          # Flakes, GC, store optimization
│   │   ├── security.nix              # sops-nix secrets management
│   │   └── user.nix                  # User account & groups
│   └── features/
│       ├── default.nix               # Imports all feature modules
│       ├── desktop.nix               # Plasma 6, audio, printing, scanning
│       ├── dev.nix                   # Dev tools, nix-ld
│       └── nvidia.nix                # Nvidia drivers & Prime config
│
├── home/phukrit7171/
│   ├── default.nix                   # Home Manager entry point
│   └── core/
│       ├── shell.nix                 # Fish, Starship, Direnv
│       ├── git.nix                   # Git config
│       └── packages.nix              # User packages
│
└── secrets/                          # (Create manually)
    └── secrets.yaml                  # sops-encrypted secrets
```

## 🚀 Usage

### Apply Configuration

```bash
# Using nh (recommended)
nh os switch .

# Or using nixos-rebuild
sudo nixos-rebuild switch --flake .#nixos-phukrit
```

### Update Flake Inputs

```bash
nix flake update
```

### Format Code

```bash
nix fmt
```

### Enter Dev Shell

```bash
nix develop
```

## 🔧 Module System

All modules use `lib.mkEnableOption` and `lib.mkIf` for clean toggling in `configuration.nix`:

```nix
# Enable/disable features in hosts/nixos-phukrit/configuration.nix
modules.core.boot.enable = true;
modules.core.system.enable = true;
modules.core.nix.enable = true;
modules.core.user.enable = true;
modules.core.security.enable = true;

modules.features.desktop.enable = true;
modules.features.desktop.printing.enable = true;
modules.features.desktop.scanning.enable = true;
modules.features.nvidia.enable = true;
modules.features.dev.enable = true;
```

## 🔐 Secrets Setup (sops-nix)

1. Generate an Age key:
   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   ```

2. Create `.sops.yaml` at repo root:
   ```yaml
   keys:
     - &phukrit age1xxxxxxxxx...  # Your public key from step 1
   creation_rules:
     - path_regex: secrets/.*\.yaml$
       key_groups:
         - age:
             - *phukrit
   ```

3. Create encrypted secrets:
   ```bash
   mkdir -p secrets
   sops secrets/secrets.yaml
   ```

4. Uncomment secrets in `modules/nixos/core/security.nix`.

## 📝 License

Personal configuration — feel free to reference for your own setup.
