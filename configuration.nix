{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./system/options.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Kolkata";

  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  security.sudo.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };

  services.displayManager.ly.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.northee = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  programs.niri.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";            # or "daily"
    options = "--delete-older-than 14d";
  };

  # Optional but recommended: keep /boot from filling up by cleaning old boot entries
  boot.loader.systemd-boot.configurationLimit = 10;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    alacritty
    git
    niri
    xwayland-satellite
  ];
  
  fonts.packages= with pkgs; [
    nerd-fonts.jetbrains-mono  
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.tailscale = {
      enable = true;
  };
  services.sunshine = {
  autoStart = true;
  openFirewall = true;
  capSysAdmin = true;
  };

  
  system.stateVersion = "26.05";
}

