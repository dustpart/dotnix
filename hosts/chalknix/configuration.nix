# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:


let
  #aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
   #   aagl-gtk-on-nix.module
      inputs.home-manager.nixosModules.default
    ];
  virtualisation.docker.enable = true;
  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  # Experimental features

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #Apparently this should work apps being slow
  boot.kernelParams = [ "intel_pstate=active" ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "chalknix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Disable IPv6
  networking.enableIPv6 = false;
  #boot.kernelParams = ["ipv6.disable=1"];

  # Set your time zone.
  time.timeZone = "America/Argentina/Cordoba";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_AR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };
  
  services.twingate.enable = true;
  
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
  
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  jack.enable = true;

};
  # Configure keymap in X11
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    #displayManager.sddm.theme = "where_is_my_sddm_theme";
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zektak = {
    isNormalUser = true;
    description = "zektak";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      git
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "zektak" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  

  environment.sessionVariables = {
    FLAKE = "/etc/nixos";
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (pkgs.waybar.overrideAttrs (oldAttrs:  {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )
    pkgs.cachix
    nh
    ani-cli
    floorp
    xwaylandvideobridge
    #pkgs.home-manager
    pkgs.mako
    libnotify
    swww
    kitty  
    rofi-wayland
    firefox
    neovim
    (pkgs.discord.override {
      # remove any overrides that you don't want
      withOpenASAR = true;
      withVencord = true;
    })
    steam
    where-is-my-sddm-theme
    pkgs.networkmanagerapplet
    pcmanfm
    p7zip
    unzip
    nomacs
    spotify  
    pkgs.vesktop
#  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  programs.hyprland = {
	enable = true;
	#enableNvidiaPatches = true;
	xwayland.enable = true;
};

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";

  };

  hardware = {
	opengl.enable = true;
	opengl.driSupport = true;
	opengl.driSupport32Bit = true;
	nvidia.modesetting.enable = true;	
	nvidia.open = false;
	nvidia.nvidiaSettings = true;
	nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
};

  services.xserver.videoDrivers = ["nvidia"];
  
  services.dbus.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  
  nix.settings = {
    substituters = [ "https://ezkea.cachix.org" ];
    trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
  };
  
  #programs.anime-game-launcher.enable = true;

}


