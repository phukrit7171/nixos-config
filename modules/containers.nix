{
  # nix-container
  boot.enableContainers = true;

  # other linux containers
  virtualisation = {
    containers = {
      enable = true;
      registries = {
        search = [ "docker.io" ];
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };
}
