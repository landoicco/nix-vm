# This VM's NixOS configuration, built on nix-vm. install.sh sets the
# desktop and the nix-vm URL.
{
  description = "NixOS configuration for this VM";

  inputs.nix-vm.url = "github:landoicco/nix-vm";

  outputs =
    { nix-vm, ... }:
    let
      desktop = "kde";
    in
    {
      # Named after the hostname, so a plain `nixos-rebuild switch` finds it
      nixosConfigurations.nix-vm = nix-vm.inputs.nixpkgs.lib.nixosSystem {
        modules = [
          nix-vm.nixosModules.development
          nix-vm.nixosModules.${desktop}
          ./hardware-configuration.nix
          ./configuration.nix
        ];
      };
    };
}
