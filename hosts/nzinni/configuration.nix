# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../../modules/bluetooth.nix
      ./../../modules/laptop_scaling.nix
      ./../../modules/intel_d.nix
      ./../../modules/virtualization.nix
      ./../../cachix.nix
      inputs.home-manager.nixosModules.default
      inputs.niri.nixosModules.niri      
    ];

  #security.wrappers.ubridge = {
  #  source = "${pkgs.ubridge}/bin/ubridge";
  #  capabilities = "cap_net_admin,cap_net_raw=ep";
  #  owner = "root";
  #  group = "root";  # or whatever group your user belongs to
  #};
  #nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

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
  #Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "latam";
    xkb.variant = "";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  services.pulseaudio.enable = false;
  security.pam.services.hyprlock.text = "auth include login";
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
 
   virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nzinni = {
    isNormalUser = true;
    description = "Nicolás Zinni";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      rustdesk
      direnv
      mysql-workbench
      pkgs.cachix
      kdePackages.kate
      bottles
      tidal-hifi
      kalker
      calcure
      ipcalc
      speedcrunch
      bottles
      gns3-gui
      inputs.zen-browser.packages.${pkgs.system}.default
      neovim
      rustup
      rust-analyzer
      #ciscoPacketTracer8
      ghostty
     #  thunderbird
    ];
  };
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "nzinni" = import ./home.nix;
    };
  };
  # Install firefox.
  programs.firefox.enable = true;
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  #  pkgs.sony-headphones-client
    spotify
    libreoffice-qt
    hunspell
    hunspellDicts.es_AR
    pkgs.nh
    git
    pkgs.jetbrains.rider
    input-leap
    emacs  # Or emacsGit for latest
    ripgrep
    fd
    inetutils
    cmake
    openssl
    pkg-config
    gcc
    mako
    eww
    swww
    fuzzel
    clipse
    cliphist
    yazi
    fzf
    p7zip
    imagemagick
    zoxide
    ffmpeg
    networkmanagerapplet
    iwd
    brightnessctl
    xwayland-satellite
    godot_4
    #gomod2nix
    #gns3-server
    #libvirt
    #ubridge
  ];
  
  #programs.zsh.enable = true;  # Needed if using zsh for DOOMDIR
  services.emacs.enable = true; 
  
  fonts.packages = with pkgs; [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.sauce-code-pro
    pkgs.nerd-fonts.noto
    pkgs.nerd-fonts.roboto-mono
    pkgs.nerd-fonts.iosevka
    pkgs.font-awesome
    pkgs.comic-mono
    pkgs.icomoon-feather
  ]; 

  services.mopidy = {
    enable = true;
    extensionPackages = [ pkgs.mopidy-notify pkgs.mopidy-bandcamp pkgs.mopidy-mpd pkgs.mopidy-iris];
  };
  
  services.tailscale.enable = true;
  
  #services.gns3-server = {
    #enable = true;
    #dynamips.enable = true;
    #ubridge.enable = true;
    #vpcs.enable = true;
    #settings = {
    #  host = "127.0.0.1";
    #  port = 3080;
    #};
 # };

  #services.n8n = {
   # enable = true;
  #};
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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

}
