# git with the user's public identity.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nix-vm.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.nix-vm.git.enable {
    environment.systemPackages = [ pkgs.git ];

    home-manager.users.licaza.programs.git = {
      enable = true;
      settings.user = {
        name = "Lando Icaza";
        email = "landoicco@gmail.com";
      };
    };
  };
}
