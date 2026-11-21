# Claude Code from nixpkgs-unstable (see the overlay in flake.nix); its
# CLAUDE.md and settings.json are plain files copied once to ~/.claude.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nix-vm.claudeCode.enable = lib.mkEnableOption "Claude Code";

  config = lib.mkIf config.nix-vm.claudeCode.enable {
    environment.systemPackages = [ pkgs.claude-code ];

    # Only when missing, so edits made by Claude or by hand survive rebuilds.
    # A home-manager module, since lib.hm only exists there.
    home-manager.users.licaza =
      { lib, ... }:
      {
        home.activation.claudeConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          for f in CLAUDE.md settings.json; do
            if [ ! -e "$HOME/.claude/$f" ]; then
              run mkdir -p "$HOME/.claude"
              run install -m 644 ${../../config/claude}/"$f" "$HOME/.claude/$f"
            fi
          done
        '';
      };
  };
}
