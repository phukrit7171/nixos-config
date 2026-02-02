{ pkgs, ... }:

{
  # 1. USER CONFIG
  users.users.phukrit7171 = {
    isNormalUser = true;
    description = "Phukrit Kittinontana";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "plugdev"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      # Browsers
      brave
      microsoft-edge
      google-chrome

      # Editors/Dev
      vscode
      zed-editor
      fnm
      uv

      # Social/Tools
      discord-ptb
      tree
    ];
  };

  # 2. SHELL & TERMINAL
  programs.starship.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fnm env --use-on-cd | source
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # 3. SYSTEM PACKAGES (Available to all users)
  environment.systemPackages = with pkgs; [
    vim
    neovim
    helix
    wget
    curl
    git
    grc
    sbctl
    libfido2
    usbutils
    nil
    nixd
  ];

  # 4. PROGRAMS CONFIG
  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    config = {
      user.name = "Mr.Phukrit Kittinontana";
      user.email = "phukrit7171@gmail.com";
      init.defaultBranch = "main";
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];
}
