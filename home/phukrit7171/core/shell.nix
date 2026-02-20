{ ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fnm env --use-on-cd | source
    '';
  };

  programs.starship.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
