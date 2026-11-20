# zsh + Powerlevel10k; the p10k config is a plain file at ~/.p10k.zsh.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nix-vm.zsh.enable = lib.mkEnableOption "zsh with Powerlevel10k";

  config = lib.mkIf config.nix-vm.zsh.enable {
    # Makes zsh a valid login shell
    programs.zsh.enable = true;
    users.users.licaza.shell = pkgs.zsh;

    # Powerlevel10k's recommended font
    fonts.packages = [ pkgs.meslo-lgs-nf ];

    home-manager.users.licaza.programs.zsh = {
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
          [[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
          # U+2744 alone renders as text; use an emoji-presentation glyph instead
          typeset -g POWERLEVEL9K_NIX_SHELL_VISUAL_IDENTIFIER_EXPANSION='🧊'
        ''
      ];
    };
  };
}
