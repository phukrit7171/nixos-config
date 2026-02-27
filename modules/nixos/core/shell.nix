{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fnm env --use-on-cd --shell fish | source
      fnm completions --shell fish | source
    '';
  };
  
  users.defaultUserShell = pkgs.fish;

  programs.starship.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
