# User environment for licaza: zsh + Powerlevel10k and Doom's config.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  # The repo must be cloned here; see docs/decisions.md
  repo = "${config.home.homeDirectory}/nix-vm";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # Up/down cycle through history entries matching what is typed
    historySubstringSearch = {
      enable = true;
      # Terminals send either sequence for the arrow keys
      searchUpKey = [
        "^[[A"
        "^[OA"
      ];
      searchDownKey = [
        "^[[B"
        "^[OB"
      ];
    };
    # A project's dev shell with zsh instead of bash
    shellAliases.nd = "nix develop -c zsh";
    initContent = lib.mkMerge [
      # Powerlevel10k instant prompt; must stay at the top of .zshrc
      (lib.mkBefore ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ~/.p10k.zsh
      ''
    ];
  };

  # Linked to the clone, so edits apply right away and can be committed
  home.file.".p10k.zsh".source = link "config/p10k.zsh";
  xdg.configFile."doom".source = link "config/doom";

  home.stateVersion = "26.05";
}
