{ pkgs, ... }:

{
  # SECRETS MANAGEMENT (sops-nix)
  # WARNING: Requires manual age key generation and secrets.yaml creation.

  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];

  sops.defaultSopsFile = ../../../secrets/secrets.yaml; # Placeholder path
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/phukrit7171/.config/sops/age/keys.txt";

  # Example secret (Uncomment when secrets.yaml exists)
  # sops.secrets."example-secret" = {};
}
