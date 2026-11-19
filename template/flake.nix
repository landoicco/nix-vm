# This VM's NixOS configuration, built on nix-vm. install.sh sets the
# desktop, the hostname and the nix-vm URL.
{
  description = "NixOS configuration for this VM";

  inputs.nix-vm.url = "github:landoicco/nix-vm";

  outputs =
    { nix-vm, ... }:
    let
      desktop = "kde";
      hostname = "nix-vm";
    in
    {
      # Named after the hostname, so a plain `nixos-rebuild switch` finds it
      nixosConfigurations.${hostname} = nix-vm.inputs.nixpkgs.lib.nixosSystem {
        modules = [
          nix-vm.nixosModules.development
          nix-vm.nixosModules.${desktop}
          ./hardware-configuration.nix
          ./configuration.nix
          { networking.hostName = hostname; }
        ];
      };
    };
}
