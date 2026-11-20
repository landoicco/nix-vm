# Polybar for i3: workspaces, window title, CPU, memory, disk, network and clock.
# Override a color from a VM's flake, e.g. nix-vm.polybar.colors.accent = "#83a598";
{ config, lib, ... }:

let
  colors = config.nix-vm.polybar.colors;
  # Nerd Font glyphs, all in MesloLGS NF
  icon = glyph: {
    prefix.text = "${glyph} ";
    prefix.foreground = "\${colors.accent}";
  };
in
{
  options.nix-vm.polybar.colors = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    description = "Bar colors; each one can be overridden on its own.";
  };

  config = {
    # Gruvbox dark; mkDefault lets a VM override single colors
    nix-vm.polybar.colors = lib.mapAttrs (_: lib.mkDefault) {
      bg = "#282828";
      surface = "#3c3836";
      fg = "#ebdbb2";
      muted = "#a89984";
      dim = "#665c54";
      accent = "#fe8019";
    };

    home-manager.users.licaza.services.polybar = {
      enable = true;
      script = "polybar main &";
      settings = {
        inherit colors;

        settings.screenchange-reload = true;

        "bar/main" = {
          width = "100%";
          height = 26;
          background = "\${colors.bg}";
          foreground = "\${colors.fg}";
          line-size = 2;
          padding-right = 1;
          module-margin = 1;
          font = [ "MesloLGS NF:size=10;2" ];
          separator = "│";
          separator-foreground = "\${colors.dim}";
          modules-left = "xworkspaces";
          modules-center = "xwindow";
          modules-right = "cpu memory fs network date";
          cursor-click = "pointer";
          wm-restack = "i3";
        };

        # i3 publishes its workspaces through EWMH, so polybar needs no i3 support
        "module/xworkspaces" = {
          type = "internal/xworkspaces";
          format.prefix = {
            text = "";
            foreground = "\${colors.accent}";
            padding = 1;
          };
          label.active = {
            text = "%name%";
            background = "\${colors.surface}";
            underline = "\${colors.accent}";
            padding = 1;
          };
          label.occupied = {
            text = "%name%";
            padding = 1;
          };
          label.urgent = {
            text = "%name%";
            foreground = "\${colors.bg}";
            background = "\${colors.accent}";
            padding = 1;
          };
          label.empty = {
            text = "%name%";
            foreground = "\${colors.dim}";
            padding = 1;
          };
        };

        "module/xwindow" = {
          type = "internal/xwindow";
          label = {
            text = "%title:0:60:…%";
            foreground = "\${colors.muted}";
          };
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format = icon "";
          label = "%percentage%%";
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 3;
          format = icon "󰍛";
          label = "%gb_used%";
        };

        "module/fs" = {
          type = "internal/fs";
          interval = 30;
          mount = [ "/" ];
          format.mounted = icon "󰋊";
          label.mounted = "%percentage_used%%";
        };

        "module/network" = {
          type = "internal/network";
          interface-type = "wired";
          interval = 5;
          format.connected = icon "󰈀";
          label.connected = "%local_ip%";
          format.disconnected = icon "󰈀";
          label.disconnected = {
            text = "offline";
            foreground = "\${colors.dim}";
          };
        };

        "module/date" = {
          type = "internal/date";
          interval = 5;
          date = "%a %d %b";
          time = "%H:%M";
          format = icon "";
          label = "%date%  %time%";
        };
      };
    };
  };
}
