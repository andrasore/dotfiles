# This config file is supposed to be _symlinked_ to /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan. Use absolute path so
      # symlinking this file should work.
      /etc/nixos/hardware-configuration.nix
      ./home-manager.nix
      ./host.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  hardware.bluetooth.enable = true;

  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      terminus_font
      terminus_font_ttf
      font-awesome
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto" ];
        sansSerif = [ "Noto" ];
      };
    };
  };

  # Enable sound.
  services.pipewire = {
   enable = true;
   alsa.enable = true;
   pulse.enable = true;
   jack.enable = true;
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
     extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
     initialPassword = "changemeplz"; };

  environment = {
    sessionVariables = {
        GRIM_DEFAULT_DIR = "/home/andras/Pictures";
    };
    # Start Sway on logging in from tty1
    loginShellInit = ''
      if [ -z $DISPLAY  ] && [ "$(tty)" = "/dev/tty1"  ]; then
            exec sway
      fi
    '';
  };

  # For building the cursor theme
  nixpkgs.config.permittedInsecurePackages = [
    "imagemagick-6.9.12-68"
  ];

  environment.systemPackages = with pkgs; [
   # Basic utilities
     curl
     emacs29-gtk3
     fd
     git
     ripgrep
     neovim
     wget
     tldr
     zip
     unzip
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
     tango-icon-theme
     hackneyed # Mouse cursors
     glib # Gsettings
     networkmanagerapplet
     alsa-utils
     pavucontrol
     xdg-utils # For xdg-open etc
   # Applications
     firefox
     xfce.thunar
  ] ++ (import ./extra-packages.nix pkgs);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.emacs.defaultEditor = true;

  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  services.blueman.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

