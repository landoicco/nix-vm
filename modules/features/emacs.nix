# Emacs and Doom's tools come from Nix; Doom itself lives in ~/.config/emacs.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nix-vm.emacs.enable = lib.mkEnableOption "Emacs with Doom's tools";

  config = lib.mkIf config.nix-vm.emacs.enable {
    environment.systemPackages = with pkgs; [
      emacs
      ripgrep
      fd
      # To compile vterm's module
      cmake
      gnumake
      gcc
      libtool
      # Linting for :lang sh
      shellcheck
    ];

    # Icons for the modeline and file tree
    fonts.packages = [ pkgs.nerd-fonts.symbols-only ];

    # The `doom` command
    environment.sessionVariables.PATH = [ "$HOME/.config/emacs/bin" ];
  };
}
