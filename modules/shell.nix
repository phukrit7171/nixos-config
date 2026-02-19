{ pkgs, ... }:

{
  # Default shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fnm env --use-on-cd | source
    '';
  };

  programs.starship.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # CLI utilities (available system-wide)
  environment.systemPackages = with pkgs; [
    tree
    htop
    btop
    grc
    wget
    curl
  ];
}
