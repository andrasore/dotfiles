{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.useGlobalPkgs = true;

  home-manager.users.andras = {
    home.stateVersion = "23.05";
    programs.bash.enable = true;
    # These config files are just linked to their proper directories
    xdg.configFile."sway/config".source = ../dot_config/sway/config; 
    xdg.configFile."waybar/config".source = ../dot_config/waybar/config; 
    xdg.configFile."waybar/style.css".source = ../dot_config/waybar/style.css;
    xdg.configFile."foot/foot.ini".source = ../dot_config/foot/foot.ini;
    home.file.".doom.d/config.el".source = ../dot_doom.d/config.el;
    home.file.".doom.d/init.el".source = ../dot_doom.d/init.el;
    home.file.".doom.d/packages.el".source = ../dot_doom.d/packages.el;
  };
}
