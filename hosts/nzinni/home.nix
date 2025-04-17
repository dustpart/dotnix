{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.niri.homeModules.niri ];
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
          path = "~/Downloads/WALLPAPERS/SPIDERVERSE/greenish/SPDRVRS-5.png";
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
    enable = true; 
    settings = {
      binds = {
        "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
        "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
        "Mod+D".action.spawn = "fuzzel";
        "Mod+Enter".action.spawn = "ghostty";
        "Mod+1".action.focus-workspace = 1;
      };
     # spawn-at-startup = [
    #    {command = ["swww-daemon"];}
   #     {command = ["eww" "daemon"];}
  #      {command = ["eww" "open" "bar"];}
 #       {command = ["wl-paste" "--type" "image" "--watch" "cliphist" "store"];}
#        {command = ["wl-paste" "--type" "text" "--watch" "cliphist" "store"];} 
#      ];
      outputs = {
        "eDP-1" = {
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
