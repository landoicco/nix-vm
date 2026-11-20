# i3 with home-manager's default keys on Win, dmenu (Mod+d), Alacritty (Mod+Enter)
# and polybar instead of i3bar. nitrogen sets the wallpaper; PCManFM browses files.
{ pkgs, ... }:

{
  imports = [
    ./polybar.nix
    ./vbox-resize.nix
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.i3.enable = true;
  # dmenu comes from home-manager's config, and polybar replaces i3status
  services.xserver.windowManager.i3.extraPackages = [ ];
  services.displayManager.defaultSession = "none+i3";

  environment.systemPackages = [
    pkgs.alacritty
    pkgs.nitrogen
    pkgs.pcmanfm
  ];
  # i3-sensible-terminal would pick xterm first
  environment.sessionVariables.TERMINAL = "alacritty";

  home-manager.users.licaza = {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        # Bindings are sorted, so Mod+0 would make i3 start on workspace 10
        defaultWorkspace = "workspace number 1";
        bars = [ ];
        # Also after Mod+Shift+r, so the bar comes back with i3
        startup = [
          {
            command = "systemctl --user restart polybar";
            always = true;
            notification = false;
          }
        ];
      };
    };
    # Replaces the config from i3's first-login wizard on existing VMs
    xdg.configFile."i3/config".force = true;
  };

  # i3 has no wallpaper of its own; pick one with nitrogen, redrawn to fit
  nix-vm.vboxResize.afterResize = "${pkgs.nitrogen}/bin/nitrogen --restore || true";

  # Keeps VS Code and Brave logins
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
}
