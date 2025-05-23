{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.ags.homeManagerModules.default ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nzinni";
  home.homeDirectory = "/home/nzinni";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.iwgtk
    inputs.ags.packages.${pkgs.system}.io
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
  services.mako = {
    enable = true;
  };

  programs.ags = {
    enable = true;

    # symlink to ~/.config/ags
    configDir = ../../modules/ags;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      inputs.ags.packages.${pkgs.system}.battery
      inputs.ags.packages.${pkgs.system}.network
      inputs.ags.packages.${pkgs.system}.wireplumber
      #inputs.ags.packages.${pkgs.system}.
      fzf
    ];
  };  

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        immediate_render = true;
        hide_cursor = false;
      };
      background = [
        {
          monitor = "";
          path = "/home/nzinni/Imágenes/wallpaper.png";
          blur_passes = 3;
          blur_size = 12;
          noise = "0.1";
          contrast = "1.3";
          brightness = "0.2";
          vibrancy = "0.5";
          vibrancy_darkness = "0.3";
        }
      ];
    };
  };
  programs.niri = { 
    settings = {
      environment = {
        QT_QPA_PLATFORM = "wayland";
        DISPLAY = ":12";
    };
      binds = with config.lib.niri.actions;{
        "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
        "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
        "XF86MonBrightnessUp".action = spawn "brightnessctl" "s" "+5%";
        "XF86MonBrightnessDown".action = spawn "brightnessctl" "s" "5%-";
        "Print".action = spawn "grim" "-g" "$(slurp)" "-" "|" "swappy" "-f" "-";
        "Mod+D".action = spawn "fuzzel";
        "Mod+Return".action = spawn "ghostty";
        "Mod+1".action = focus-workspace 1;
        "Mod+Shift+E".action = quit { skip-confirmation = true; };
        "Mod+Shift+F".action = toggle-window-floating;
        "Mod+Ctrl+F".action = fullscreen-window;
        "Mod+Q".action = close-window; 
      };
      spawn-at-startup = [
        {command = ["swww-daemon"];}
        {command = ["swww" "img" "/home/nzinni/Imágenes/wallpaper.png"];}
        {command = ["xwayland-satellite" ":12"];}
        {command = ["eww" "daemon"];}
        {command = ["eww" "open" "bar"];}
        {command = ["wl-paste" "--type" "image" "--watch" "cliphist" "store"];}
        {command = ["wl-paste" "--type" "text" "--watch" "cliphist" "store"];} 
      ];
      outputs = {
        "eDP-1" = {
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
        };
      };
      input = {
        keyboard = {
          xkb = {
              layout = "latam";
              variant = "";
          };
        };
        touchpad = {
          click-method = "button-areas";
          dwt = true;
          dwtp = true;
          natural-scroll = true;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
          middle-emulation = true;
          accel-profile = "adaptive";
          # scroll-factor = 0.2;
        };
      };  
    };
  };
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/zektak/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    #DISPLAY = ":12";
  };
  programs.bash = {
    #enable = true;
    sessionVariables = {
      DISPLAY = ":12";
      XKB_DEFAULT_LAYOUT = "latam";
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
