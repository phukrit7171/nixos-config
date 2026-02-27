{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Mr.Phukrit Kittinontana";
    userEmail = "phukrit7171@gmail.com";

    # ค่าคอนฟิกอื่นๆ ให้ใส่ใน extraConfig
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    includes = [
      {
        condition = "gitdir:/home/phukrit7171/Development/bu8/";
        contents = {
          user = {
            email = "phukrit.k@chanwanich.digital";
          };
          credential = {
            helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
            credentialStore = "secretservice";
          };
        };
      }
    ];
  };
}
