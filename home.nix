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
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      # Source ~/.bashrc.d/*
      if [ -d "$HOME/.bashrc.d" ]; then
        for rc in "$HOME"/.bashrc.d/*; do
          [ -f "$rc" ] && . "$rc"
        done
      fi
      unset rc
    '';

    shellAliases = {
      nixos-update = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/os-files#northee-dtp";
      home-update = "nix run github:nix-community/home-manager/release-25.11 -- switch --flake ${config.home.homeDirectory}/os-files#work-ltp";
    };
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    luajitPackages.luarocks
    nixpkgs-fmt
    nodejs
    sunshine
    moonlight-qt
    gcc
    gh
    google-cloud-sdk
    fuzzel
    brave
    wezterm
    clang-tools
    htop
    below
    oxker
    vlc
    fd
    bat
    yazi
    chafa
    dive
    doxygen
    dunst
    zed-editor
  ];

  home.file.".bashrc.d".source =
    config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/bashrc.d";

}
