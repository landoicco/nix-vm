# 🧭 Decisions

- 🧊 VMs are disposable: nothing machine-specific lives in this repo.
- 📥 VMs only consume the repo (clone and pull); nobody pushes from them.
- 🔧 Hardware comes from `/etc/nixos/hardware-configuration.nix` (`--impure`).
- 🖥️ One flake output per desktop: `xfce`, `kde`, `gnome`.
- 🥾 BIOS only: GRUB on `/dev/sda`, MBR with root and 4 GiB swap.
- 🪪 Fixed hostname `nix-vm` and user `licaza`.
- 🏷️ Track stable (`nixos-26.05`, `release-26.05`); bump both on each NixOS release.
- 📦 No `flake.lock` in git: each VM locks the latest stable at install time.
- 📍 Flake referenced as `path:`, since Nix ignores untracked lock files in git flakes.
- 🏠 home-manager as a NixOS module, only for zsh, p10k, git and Doom's config.
- 📁 Clone at `~/nix-vm`: p10k and Doom configs are symlinked from it.
- 🧠 Doom uses tree-sitter but no LSP; language tooling comes from each project's flake.
- 🧩 VS Code is installed only; extensions and settings are unmanaged.
- 🧹 Weekly Nix GC (older than 7 days), store optimisation and Docker auto-prune.
- 🔒 No secrets in this repo; the user password is set during install.
- 📧 The git identity (name and email) is public on purpose.
- 🛡️ VMs are isolated from the host: no shared clipboard, drag and drop or folders.
