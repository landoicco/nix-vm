# i3 brings dmenu (Mod+d) and i3status; Alacritty opens with Mod+Enter.
# nitrogen sets the wallpaper.
{ pkgs, ... }:

{
  imports = [ ./vbox-resize.nix ];

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.displayManager.defaultSession = "none+i3";

  environment.systemPackages = [
    pkgs.alacritty
    pkgs.nitrogen
  ];
  # i3-sensible-terminal would pick xterm first
  environment.sessionVariables.TERMINAL = "alacritty";

  # i3 has no wallpaper of its own; pick one with nitrogen, redrawn to fit
  nix-vm.vboxResize.afterResize = "${pkgs.nitrogen}/bin/nitrogen --restore || true";

  # Keeps VS Code and Brave logins
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
}
