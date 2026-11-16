# Emacs and Doom's tools come from Nix; Doom itself lives in ~/.config/emacs.
{ pkgs, ... }:

{
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

  # Icons for the modeline and file tree; Symbola as the fallback font
  fonts.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.symbola
  ];

  # The `doom` command
  environment.sessionVariables.PATH = [ "$HOME/.config/emacs/bin" ];
}
