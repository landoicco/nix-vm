# i3 brings dmenu (Mod+d) and i3status; Alacritty opens with Mod+Enter.
{ pkgs, ... }:

{
  imports = [ ./vbox-resize.nix ];

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.displayManager.defaultSession = "none+i3";

  environment.systemPackages = [ pkgs.alacritty ];
  # i3-sensible-terminal would pick xterm first
  environment.sessionVariables.TERMINAL = "alacritty";

  # Keeps VS Code and Brave logins
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
}
