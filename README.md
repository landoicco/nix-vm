# 🧊 nix-vm

NixOS development environment bootstrap for disposable VMs.

## 📦 What you get

- 🖥️ Desktop of choice: XFCE, KDE, GNOME or i3
- 🐚 zsh + Powerlevel10k, with history substring search
- ✍️ Doom Emacs and VS Code
- 🐳 Docker, git and Brave
- 🧰 CLI basics: zip, unzip, htop, tree, jq, file
- 🧹 Self-cleaning: weekly Nix GC and Docker prune
- 📌 Pinned versions: every VM starts from the same `flake.lock`
- ✍️ Its own flake in `/etc/nixos`, ready for per-VM changes

## 🚀 Quick start

Boot the NixOS minimal ISO in a new VirtualBox VM, then:

```bash
curl -LO https://raw.githubusercontent.com/landoicco/nix-vm/main/install.sh
sudo bash install.sh   # asks for the desktop and hostname
```

## 🗂️ Layout

```
modules/core.nix       # shared by every VM
modules/disk.nix       # disk layout (disko)
modules/features/      # one tool per file, with an enable option
modules/desktops/      # xfce, kde, gnome, i3
profiles/              # which features a VM gets
template/              # each VM's /etc/nixos
config/                # Doom and p10k configs, copied at install
```

## 📚 Docs

- 📖 [Guide](docs/guide.md): create, install, use and delete a VM
- 🧭 [Decisions](docs/decisions.md)
