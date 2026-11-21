# 🧊 nix-vm

NixOS development environment bootstrap for disposable VMs.

## 📦 What you get

- 🖥️ Desktop of choice: XFCE, KDE, GNOME or i3
- 🐚 zsh + Powerlevel10k, with history substring search
- ✍️ Doom Emacs and VS Code
- 🐳 Docker, git and Brave
- 🧰 CLI basics: zip, unzip, htop, tree, jq, file
- 🤖 Optional Claude Code, with its config ready, and Cursor
- 🧹 Self-cleaning: weekly Nix GC and Docker prune
- 📌 Pinned versions, and each VM's own flake in `/etc/nixos` for its changes

## 🚀 Quick start

Boot the NixOS minimal ISO in a new VirtualBox VM, then:

```bash
curl -LO https://raw.githubusercontent.com/landoicco/nix-vm/main/install.sh
sudo bash install.sh   # asks for the desktop and hostname
```

## 📚 Docs

- 📖 [Guide](docs/guide.md): create, install, use and delete a VM
- 🧭 [Decisions](docs/decisions.md)
