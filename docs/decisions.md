# 🧭 Decisions

## 🧱 Structure

- 📚 The repo is a base, not a machine: it exports `nixosModules` and a flake template.
- 🏠 Each VM has its own flake in `/etc/nixos`, with nix-vm as an input.
- 📍 `/etc/nixos` is root-owned and a local git repo with no remote; `nixos-rebuild switch` needs no arguments.
- ✍️ A VM's own changes go in its `configuration.nix`; the repo is never edited from a VM.
- 🧩 One file per feature in `modules/features`, holding both its NixOS and home-manager parts, toggled by `nix-vm.<feature>.enable`.
- 🎛️ Profiles turn features on with `mkDefault`, so a VM can turn any off; for now there is one, `development`.
- 🖥️ One module per desktop: `xfce`, `kde`, `gnome`, `i3`.
- 🪟 i3 is the light desktop: X11 runs well in VirtualBox, while Wayland compositors like Hyprland need real 3D acceleration. It uses its default config, dmenu, Alacritty and nitrogen for the wallpaper; i3 itself splits the screen, so no tmux.
- 🪶 No flake-parts: a plain flake is enough for one system and a few outputs.

## 📌 Reproducibility

- 🔒 `flake.lock` is in git: every VM starts from the same pinned versions.
- 🔄 Updates are deliberate: `nix flake update` in the repo, test, commit; each VM follows with `nix flake update nix-vm`.
- ✅ CI (GitHub Actions, `cachix/install-nix-action`) runs `nix flake check --no-build` on every pull request and push to `main`; it evaluates, it does not build.
- 🧪 install.sh locks the VM's flake before installing, so Nix never sees it change mid-install.
- 🔧 Hardware comes from `nixos-generate-config --no-filesystems`, kept in the VM's `/etc/nixos`; no `--impure`.
- 💽 disko partitions the disk from `modules/disk.nix`.
- 📅 `stateVersion` lives in each VM's `configuration.nix`: set at install, never changed.
- 🏷️ Track stable (`nixos-26.05`, `release-26.05`); on each NixOS release, bump both and the template's `stateVersion`.

## 🖥️ VMs

- 🧊 VMs are disposable: nothing machine-specific lives in this repo.
- 🥾 BIOS only: GPT with a BIOS boot partition for GRUB, root and 4 GiB swap on `/dev/sda`.
- 🪪 install.sh asks for the hostname (`nix-vm` by default) and writes it to the VM's `flake.nix`, which names its configuration after it; the user is always `licaza`.
- 🛡️ VMs are isolated from the host: no shared clipboard, drag and drop or folders.
- 📦 Guest Additions are on, since `nixos-generate-config` enables them on VirtualBox.

## 🧰 Tools

- 🏠 home-manager as a NixOS module, only for zsh and git.
- 📁 Doom and p10k configs are plain files copied once to `~/.config/doom` and `~/.p10k.zsh`.
- 🧠 Doom uses tree-sitter but no LSP; language tooling comes from each project's flake.
- 🧩 VS Code is installed only; extensions and settings are unmanaged.
- 🧹 Weekly Nix GC (older than 7 days), store optimisation and Docker auto-prune, unused images included (`--all`).

## 🔐 Privacy

- 🔒 No secrets in this repo; the user password is set during install.
- 📧 The git identity (name and email) is public on purpose.
