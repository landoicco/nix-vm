# A development VM: every feature on. mkDefault lets a VM's own
# configuration.nix turn any of them off.
{ lib, ... }:

{
  nix-vm = {
    cli.enable = lib.mkDefault true;
    docker.enable = lib.mkDefault true;
    emacs.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    guiApps.enable = lib.mkDefault true;
    zsh.enable = lib.mkDefault true;
  };
}
