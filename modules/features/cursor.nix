# Cursor from nixpkgs-unstable (see the overlay in flake.nix); settings
# and extensions are unmanaged, like VS Code's.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nix-vm.cursor.enable = lib.mkEnableOption "Cursor";

  config = lib.mkIf config.nix-vm.cursor.enable {
    environment.systemPackages = [ pkgs.code-cursor ];
  };
}
