# This VM's own settings, on top of nix-vm's development profile.
# Apply changes with: sudo nixos-rebuild switch
{ pkgs, ... }:

{
  # Examples:
  # environment.systemPackages = [ pkgs.btop ];
  # nix-vm.docker.enable = false;

  # AI tools, off by default; uncomment to turn one on
  # nix-vm.claudeCode.enable = true;
  # nix-vm.cursor.enable = true;

  # The release this VM was installed with; never change it
  system.stateVersion = "26.05";
  home-manager.users.licaza.home.stateVersion = "26.05";
}
