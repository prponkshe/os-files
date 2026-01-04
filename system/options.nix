{ config, lib, pkgs, ... }:

{

    services.xserver.windowManager.qtile.enable = true; 
      networking.hostName = "northee-dtp"; # Define your hostname.
    services.sunshine.enable = true;
}


