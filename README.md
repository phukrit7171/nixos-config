# 🏗️ NixOS Configuration — nixos-phukrit

Declarative NixOS configuration for a **Lenovo Legion** laptop, built with a simple, vanilla **Flake**.

## ✨ Features

| Feature | Details |
|---|---|
| **Simple Flake** | No `flake-parts`, no abstraction. Just pure Nix. |
| **System-Wide Config** | No `home-manager`. Everything is configured system-wide. |
| **Flat Modules** | `core` and `features` modules are direct file imports, extremely easy to toggle. |
| **KDE Plasma 6** | Wayland + SDDM |
| **Nvidia Prime** | Sync mode (Intel + Nvidia) |
| **BTRFS** | `compress=zstd`, `noatime`, `discard=async` |
| **Zram** | `swappiness=100` for optimal compression |
| **LUKS + TPM2** | Full disk encryption with auto-unlock |
| **sops-nix** | Secrets management (ready to configure) |
| **Nix Formatter** | Automated formatting with `nixfmt` |

## 📁 Structure

```
nixos-config/
├── flake.nix                         # Entry point (inputs & outputs)
├── flake.lock                        # Pinned dependencies
│
├── hosts/
│   └── 16ITH6H4/
│       ├── configuration.nix         # Host-specific config & module imports
│       └── hardware-configuration.nix # Hardware & BTRFS mounts
│
├── modules/nixos/
│   ├── core/                       # Core system components
│   │   ├── boot.nix                  # Bootloader, kernel, sysctl
│   │   ├── core.nix                  # Networking, Bluetooth, services
│   │   ├── git.nix                   # System-wide git config
│   │   ├── nix-settings.nix          # Flakes, GC, store optimization
│   │   ├── packages.nix              # Main user packages
│   │   ├── security.nix              # sops-nix secrets management
│   │   ├── shell.nix                 # Shell configurations (Fish)
│   │   └── user.nix                  # User account & groups
│   └── features/                   # Optional features
│       ├── desktop.nix               # Plasma 6, audio, printing, scanning
│       ├── dev.nix                   # Dev tools, nix-ld
│       └── nvidia.nix                # Nvidia drivers & Prime config
│
└── secrets/                          # (Create manually)
    └── secrets.yaml                  # sops-encrypted secrets
```

## 🚀 Usage

### Apply Configuration

```bash
# Using nixos-rebuild
sudo nixos-rebuild switch --flake .#16ITH6H4
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

All modules are strictly basic flat `.nix` files without wrapper abstractions (`lib.mkIf` etc). Enable or disable configurations by simply commenting out imports inside `hosts/16ITH6H4/configuration.nix`.

```nix
  imports = [
    # ...
    ../../modules/nixos/core/boot.nix
    ../../modules/nixos/core/core.nix
    # Comment this line to disable dev tools:
    # ../../modules/nixos/features/dev.nix
  ];
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
