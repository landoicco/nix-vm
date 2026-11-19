# Docker with a weekly prune.
{ config, lib, ... }:

{
  options.nix-vm.docker.enable = lib.mkEnableOption "Docker";

  config = lib.mkIf config.nix-vm.docker.enable {
    virtualisation.docker.enable = true;
    virtualisation.docker.autoPrune.enable = true;
    # Unused tagged images too, not only dangling ones
    virtualisation.docker.autoPrune.flags = [ "--all" ];
    users.users.licaza.extraGroups = [ "docker" ];
  };
}
