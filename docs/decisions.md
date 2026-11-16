# 🧭 Decisions

- 🧊 VMs are disposable: nothing machine-specific lives in this repo.
- 🔧 Hardware comes from `/etc/nixos/hardware-configuration.nix` (`--impure`).
- 🖥️ One flake output per desktop: `xfce`, `kde`, `gnome`.
- 🥾 BIOS only: GRUB on `/dev/sda`, MBR with root and 4 GiB swap.
- 🪪 Fixed hostname `nix-vm` and user `licaza`.
- 🏷️ Track stable (`nixos-26.05`, `release-26.05`); bump both on each NixOS release.
- 📦 No `flake.lock` in git: each VM locks the latest stable at install time.
- 📍 Flake referenced as `path:`, since Nix ignores untracked lock files in git flakes.
- 🏠 home-manager as a NixOS module, only for zsh, p10k and Doom's config.
- 📁 Clone at `~/nix-vm`: p10k and Doom configs are symlinked from it.
- 🧩 VS Code is installed only; extensions and settings are unmanaged.
- 🔒 No secrets in this repo; the user password is set during install.
- 🛡️ VMs are isolated from the host: no shared clipboard, drag and drop or folders.
