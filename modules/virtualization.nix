{ config, lib, pkgs, ... }:  {
  
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "nzinni" "zektak" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  
}

