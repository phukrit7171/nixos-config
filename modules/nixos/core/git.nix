{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    config = {
      user = {
        name = "Mr.Phukrit Kittinontana";
        email = "phukrit7171@gmail.com";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;

      "includeIf \"gitdir:/home/phukrit7171/Development/bu8/\"" = {
        path = toString (pkgs.writeText "git-bu8-config" ''
          [user]
          email = phukrit.k@chanwanich.digital
          [credential]
          helper = ${pkgs.git-credential-manager}/bin/git-credential-manager
          credentialStore = secretservice
        '');
      };
    };
  };
}
