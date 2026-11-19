{
  description = "NixOS development environment bootstrap for disposable VMs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      desktops = [
        "xfce"
        "kde"
        "gnome"
      ];
    in
    {
      # A VM's flake picks one profile and one desktop
      nixosModules = {
        core = {
          imports = [
            home-manager.nixosModules.home-manager
            ./modules/core.nix
          ];
        };
        development = {
          imports = [
            self.nixosModules.core
            ./profiles/development.nix
          ];
        };
      }
      // nixpkgs.lib.genAttrs desktops (desktop: ./modules/desktops/${desktop}.nix);

      nixosConfigurations = nixpkgs.lib.genAttrs desktops (
        desktop:
        nixpkgs.lib.nixosSystem {
          modules = [
            # Each VM keeps its own hardware config; reading it needs --impure
            /etc/nixos/hardware-configuration.nix
            self.nixosModules.development
            self.nixosModules.${desktop}
          ];
        }
      );
    };
}
