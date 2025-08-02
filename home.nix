{ config, pkgs, system, inputs, ... }:

{
  home.username = "sid";
  home.homeDirectory = "/home/sid";
  nixpkgs.config.allowUnfree = true;
  # Packages that should be installed to the user profile.
  programs = {
    nushell = {
      enable = true;
      # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
      # for editing directly to config.nu 
      extraConfig = ''
        let carapace_completer = {|spans|
        carapace $spans.0 nushell ...$spans | from json
        }
        $env.config = {
         show_banner: false,
         completions: {
         case_sensitive: false # case-sensitive completions
         quick: true    # set to false to prevent auto-selecting completions
         partial: true    # set to false to prevent partial filling of the prompt
         algorithm: "fuzzy"    # prefix or fuzzy
         external: {
         # set to false to prevent nushell looking into $env.PATH to find more suggestions
             enable: true 
         # set to lower can improve completion performance at the cost of omitting some options
             max_results: 100 
             completer: $carapace_completer # check 'carapace_completer' 
           }
         }
        } 
        $env.PATH = ($env.PATH | 
        split row (char esep) |
        prepend /home/myuser/.apps |
        append /usr/bin/env
        )
      '';
      shellAliases = { vim = "hx"; };
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };
  home.packages = [
    pkgs.zoxide
    pkgs.jetbrains.clion
    pkgs.go
    pkgs.gtk-engine-murrine
    pkgs.gnome-themes-extra
    pkgs.sassc
    pkgs.gtk3
    pkgs.lxappearance
    pkgs.fastfetch
    pkgs.firefox
    pkgs.unrar
    pkgs.redli
    pkgs.carapace
    pkgs.grim
    pkgs.fastfetch
    pkgs.qbittorrent-enhanced
    pkgs.handbrake
    pkgs.jetbrains.goland
    pkgs.tor-browser
    pkgs.thunderbird
    pkgs.spotify
    pkgs.virtualenv
    pkgs.nodePackages_latest.serve
    pkgs.jellyfin-media-player
    pkgs.brave
    pkgs.polkit_gnome
    pkgs.networkmanagerapplet
    pkgs.foot
    pkgs.qutebrowser
    pkgs.discord
    pkgs.waybar
    pkgs.protobuf
    pkgs.hyprpaper
    pkgs.chromium
    pkgs.tree
    pkgs.gh
    inputs.zen-browser.packages."${system}".twilight
  ];
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
