{
  description = "NixOS development environment bootstrap for disposable VMs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Only for fast-moving tools stable lags far behind on: Claude Code, Cursor
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      disko,
      ...
    }:
    let
      desktops = [
        "xfce"
        "kde"
        "gnome"
        "i3"
      ];
    in
    {
      # A VM's flake picks one profile and one desktop
      nixosModules = {
        core = {
          imports = [
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            ./modules/core.nix
          ];
          # These tools from unstable; the rest of pkgs stays on stable.
          # Its own nixpkgs instance, which doesn't inherit allowUnfree.
          nixpkgs.overlays = [
            (final: prev: {
              inherit
                (import nixpkgs-unstable {
                  inherit (prev.stdenv.hostPlatform) system;
                  config.allowUnfree = true;
                })
                claude-code
                code-cursor
                ;
            })
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

      # install.sh copies this to /etc/nixos on each new VM
      templates.default = {
        path = ./template;
        description = "A VM's own flake, built on nix-vm";
      };

      # install.sh runs the disko pinned in flake.lock
      packages.x86_64-linux.disko = disko.packages.x86_64-linux.disko;

      # Not installed anywhere: `nix flake check` evaluates each desktop
      nixosConfigurations = nixpkgs.lib.genAttrs desktops (
        desktop:
        nixpkgs.lib.nixosSystem {
          modules = [
            self.nixosModules.development
            self.nixosModules.${desktop}
            ./template/configuration.nix
            { nixpkgs.hostPlatform = "x86_64-linux"; }
          ];
        }
      );
    };
}
