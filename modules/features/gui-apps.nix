# Desktop apps; extensions and settings are unmanaged.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nix-vm.guiApps.enable = lib.mkEnableOption "VS Code and Brave";

  config = lib.mkIf config.nix-vm.guiApps.enable {
    environment.systemPackages = with pkgs; [
      vscode
      brave
    ];
  };
}
