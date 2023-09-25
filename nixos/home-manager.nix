{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.andras = {
    home.stateVersion = "23.05";

    home.shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
    };

    programs.bash.enable = true;

    programs.direnv.enable = true;

    programs.gh.enable = true;

    programs.git = {
      enable = true;
      userName = "Andras Sore";
      userEmail = "andras08@gmail.com";
    };

    # These config files are just linked to their proper directories
    xdg.configFile."sway/config".source = ../dot_config/sway/config; 
    xdg.configFile."waybar/config".source = ../dot_config/waybar/config; 
    xdg.configFile."waybar/style.css".source = ../dot_config/waybar/style.css;
    xdg.configFile."foot/foot.ini".source = ../dot_config/foot/foot.ini;
    # Emacs cfg files
    home.file.".doom.d/config.el".source = ../dot_doom.d/config.el;
    home.file.".doom.d/init.el".source = ../dot_doom.d/init.el;
    home.file.".doom.d/packages.el".source = ../dot_doom.d/packages.el;
  };
}
