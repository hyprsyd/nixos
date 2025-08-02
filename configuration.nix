# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  programs.hyprland.enable = true; # enable Hyprland
  programs.hyprland.withUWSM = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "sid" ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.variables.EDITOR = "nvim";
  virtualisation.docker.enable = true;

  # enable the tailscale service
  services.tailscale.enable = true;
  services.flatpak.enable = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # environment.sessionVariables = {
    #   XDG_CONFIG_HOME = "/home/sid/hyprland";
  };
  networking.hostName = "workbook"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Calcutta";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  services.postgresql = {
    enable = true;
    settings.port = 9999;
    ensureDatabases = [ "mydatabase" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host  all  all 0.0.0.0/0 scram-sha-256
    '';
  };

  services.displayManager.ly.enable = true;
  services.displayManager.environment.XDG_CURRENT_DESKTOP =
    "X-NIXOS-SYSTEMD-AWARE";
  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sid = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
      "video"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.nushell;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.nettools
    pkgs.grim
    pkgs.postgresql
    pkgs.speechd
    pkgs.pgadmin
    pkgs.ripgrep
    pkgs.python312Packages.virtualenv
    pkgs.home-manager
    pkgs.gtkmm3
    pkgs.wl-gammarelay-rs
    pkgs.gnumake
    pkgs.cmake
    pkgs.wl-clipboard
    pkgs.gsettings-qt
    pkgs.pkg-config
    pkgs.lua
    pkgs.sassc
    pkgs.starship
    pkgs.git-lfs
    pkgs.luajit
    pkgs.gtk-engine-murrine
    pkgs.glib
    pkgs.dconf-editor
    pkgs.unzip
    pkgs.rtkit
    pkgs.bottom
    pkgs.zig
    pkgs.dunst
    pkgs.pcmanfm
    pkgs.gcc
    pkgs.python3Full
    pkgs.cargo
    pkgs.rustc
    pkgs.pkg-config
    pkgs.ffmpeg
    pkgs.opencv
    pkgs.wget
    pkgs.docker-compose
    pkgs.docker
    pkgs.nodejs_22
    pkgs.nodenv
    pkgs.python311Packages.pip
    pkgs.pipx
    pkgs.kitty
    pkgs.libcamera
    pkgs.alacritty
    pkgs.p7zip
    pkgs.teams-for-linux
    pkgs.mpv
    pkgs.pavucontrol
    pkgs.rofi-wayland-unwrapped
    pkgs.nwg-look
    pkgs.gtk3
    pkgs.git
    pkgs.xdg-desktop-portal-hyprland
    pkgs.tailscale
    pkgs.wget
    pkgs.curl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

