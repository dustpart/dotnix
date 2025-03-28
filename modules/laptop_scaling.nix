{ config, lib, pkgs, ... }:  {
  services.power-profiles-daemon.enable = false;  
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
       governor = "performance";
       turbo = "auto";
    };
    charger = {
       governor = "performance";
       turbo = "auto";
    };
  };

}

