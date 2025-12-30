{ config, pkgs, ... }:


let 
  dotfiles = "${config.home.homeDirectory}/os-files/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    qtile = "qtile";
    nvim = "nvim";
    niri = "niri";
    zed = "zed";
    alacritty = "alacritty";
  };
in
{
  home.username = "northee";
  home.homeDirectory = "/home/northee";
  
  programs.git = {
    enable = true;
    settings = {
      user.name = "Pradyumna Ponkshe";
      user.email = "prponkshe173@gmail.com";
      init.defaultBranch = "main";  
      pull.rebase = true;
      credential.helper = "gh";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  })
  configs;

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    gh
    fuzzel
  ];
}
