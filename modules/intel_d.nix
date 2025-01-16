{ config, lib, pkgs, ... }:  {

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      #... # your Open GL, Vulkan and VAAPI drivers
      intel-vaapi-driver
      libvdpau-va-gl
      onevpl-intel-gpu          # for newer GPUs on NixOS >24.05 or unstable
      # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
      # intel-media-sdk   # for older GPUs
    ];
  };
  
}

