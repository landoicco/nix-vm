{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Keeps VS Code and Brave logins
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  # XFCE ignores VirtualBox resize hints; apply the host's preferred mode.
  systemd.user.services.vbox-resize = {
    description = "Follow the VirtualBox window size";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = [ pkgs.xrandr ];
    script = ''
      while true; do
        xrandr --output Virtual-1 --auto
        sleep 2
      done
    '';
  };
}
