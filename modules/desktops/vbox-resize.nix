# X11 desktops that ignore VirtualBox resize hints; apply the host's preferred mode.
{ pkgs, ... }:

{
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
