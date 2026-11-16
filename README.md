# 🧊 nix-vm

NixOS development environment bootstrap for disposable VMs.

## 📦 What you get

- 🖥️ Desktop of choice: XFCE, KDE or GNOME
- 🐚 zsh + Powerlevel10k, with history substring search
- ✍️ Doom Emacs and VS Code
- 🐳 Docker, git and Brave
- 🧰 CLI basics: zip, unzip, htop, tree, jq, file
- 🧹 Self-cleaning: weekly Nix GC and Docker prune

## 🚀 Quick start

Boot the NixOS minimal ISO in a new VirtualBox VM, then:

```bash
curl -LO https://raw.githubusercontent.com/landoicco/nix-vm/main/install.sh
sudo bash install.sh kde   # or xfce, gnome
```

## 📚 Docs

- 📖 [Guide](docs/guide.md): create, install, use and delete a VM
- 🧭 [Decisions](docs/decisions.md)
