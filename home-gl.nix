{ config, lib, nixgl, pkgs, ... }:

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
  targets.genericLinux.nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "Pradyumna Ponkshe";
        user.email = "prponkshe173@gmail.com";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
      };
    };

    bash = {
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
    yazi = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
    firefox = {
      enable = true;
    };
  };

  ## Out of Store Symlinks
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.file.".bashrc.d".source =
    config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/bashrc.d";
  #### End Out of Store Symlinks

  home.packages = with pkgs; [
    (config.lib.nixGL.wrap wezterm)
    (config.lib.nixGL.wrap niri)
    # (config.lib.nixGL.wrapOffload pkgs.freecad)
    # (config.lib.nixGL.wrappers.nvidiaPrime pkgs.xonotic)
    ripgrep
    nil
    luajitPackages.luarocks
    nixpkgs-fmt
    nodejs
    moonlight-qt
    gcc
    gh
    google-cloud-sdk
    fuzzel
    clang-tools
    htop
    below
    oxker
    vlc
    fd
    bat
    chafa
    dive
    lazygit
    doxygen
    dunst
    vulkan-tools
  ];
}
