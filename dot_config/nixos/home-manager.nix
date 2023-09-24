{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  home-manager.users.andras = {
    home.stateVersion = "23.05";
    programs.bash.enable = true;
  };
}

