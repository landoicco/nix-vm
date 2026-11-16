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
    { nixpkgs, home-manager, ... }:
    let
      mkVm =
        desktop:
        nixpkgs.lib.nixosSystem {
          modules = [
            # Each VM keeps its own hardware config; reading it needs --impure
            /etc/nixos/hardware-configuration.nix
            ./modules/base.nix
            ./modules/emacs.nix
            ./modules/desktops/${desktop}.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.licaza = import ./home.nix;
            }
          ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs [ "xfce" "kde" "gnome" ] mkVm;
    };
}
