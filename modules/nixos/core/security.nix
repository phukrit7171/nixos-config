{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  options.modules.core.security.enable =
    lib.mkEnableOption "Security Configuration (Secure Boot & Secrets)";

  config = lib.mkIf config.modules.core.security.enable {
    # 1. SECURE BOOT (Lanzaboote)
    # WARNING: Requires manual key generation with `sbctl create-keys` and enrollment with `sbctl enroll-keys`

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # 2. SECRETS MANAGEMENT (sops-nix)
    # WARNING: Requires manual age key generation and secrets.yaml creation.

    environment.systemPackages = with pkgs; [
      # Secure Boot
      sbctl

      # Secrets
      sops
      age
      ssh-to-age
    ];

    sops.defaultSopsFile = ../../../secrets/secrets.yaml; # Placeholder path
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/phukrit7171/.config/sops/age/keys.txt";

    # Example secret (Uncomment when secrets.yaml exists)
    # sops.secrets."example-secret" = {};
  };
}
