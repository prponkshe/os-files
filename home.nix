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
    backgrounds = "backgrounds";
    i3 = "i3";
    polybar = "polybar";
    noctalia = "noctalia";
    wezterm = "wezterm";
  };
in
{
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

  programs.bash = {
    enable = true;
    shellAliases = {
      nixos-update = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/os-files#northee-dtp";
    };
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
    brave
    wezterm
    clang-tools
  ];
  
  home.file.".bashrc.d".source = 
    config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/bashrc.d";

}
