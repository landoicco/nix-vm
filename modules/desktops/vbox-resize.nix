# X11 desktops that ignore VirtualBox resize hints; apply the host's preferred mode.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nix-vm.vboxResize.afterResize = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Commands to run at login and after each resize.";
  };

  config.systemd.user.services.vbox-resize = {
    description = "Follow the VirtualBox window size";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = [ pkgs.xrandr ];
    # xrandr's output changes when the host offers a new preferred mode
    script = ''
      last=""
      while true; do
        if [ "$(xrandr)" != "$last" ]; then
          xrandr --output Virtual-1 --auto
          ${config.nix-vm.vboxResize.afterResize}
          last="$(xrandr)"
        fi
        sleep 2
      done
    '';
  };
}
