# git with the user's public identity.
{ config, lib, ... }:

{
  options.nix-vm.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.nix-vm.git.enable {
    # System-wide, so root's commits in /etc/nixos carry it too
    programs.git = {
      enable = true;
      config.user = {
        name = "Lando Icaza";
        email = "landoicco@gmail.com";
      };
    };
  };
}
