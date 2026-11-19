# CLI basics missing from a default NixOS.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nix-vm.cli.enable = lib.mkEnableOption "CLI basics";

  config = lib.mkIf config.nix-vm.cli.enable {
    environment.systemPackages = with pkgs; [
      zip
      unzip
      htop
      tree
      jq
      file
    ];
  };
}
