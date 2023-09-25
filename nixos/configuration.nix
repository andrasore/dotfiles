# This config file is supposed to be _symlinked_ to /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan. Use absolute path so
      # symlinking this file should work.
      /etc/nixos/hardware-configuration.nix
      ./home-manager.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "posso"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
    # useXkbConfig = true; # use xkbOptions in tty.
  };

  fonts = {
    fonts = with pkgs; [
      terminus_font
      terminus_font_ttf
      font-awesome
      source-sans
    ];
  };

  # Enable sound.
  services.pipewire = {
   enable = true;
   alsa.enable = true;
   pulse.enable = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
  # For enabling screen sharing 
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };


  users.users.andras = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     initialPassword = "changemeplz"; };


  environment.systemPackages = with pkgs; [
   # Basic utilities
     chezmoi
     curl
     emacs29-gtk3
     fd
     git
     gh
     ripgrep
     neovim
     wget
   # For emacs vterm
     cmake
     gnumake
     gcc
     libtool
   # Programs for Sway
     foot # Terminal
     grim # Screenshot
     slurp # Screenshot
     mako # Notifications
     gammastep # For reduced blue light
     wl-clipboard
     bemenu
     wdisplays
     swaylock
     waybar
     dracula-theme
     dracula-icon-theme
     glib #gsettings
     networkmanagerapplet
     alsa-utils
     pavucontrol
   # Applications
     firefox
     xfce.thunar
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.emacs.defaultEditor = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.blueman.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

