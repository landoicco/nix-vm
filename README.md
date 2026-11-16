# 🧊 nix-vm

NixOS development environment bootstrap for disposable VMs.

## 📦 What you get

- 🖥️ Desktop of choice: XFCE, KDE or GNOME
- 🐚 zsh + Powerlevel10k
- ✍️ Doom Emacs and VS Code
- 🐳 Docker, git and Brave

## 🚀 Quick start

Boot the NixOS minimal ISO in a new VirtualBox VM, then:

```bash
curl -LO https://raw.githubusercontent.com/landoicco/nix-vm/main/install.sh
sudo bash install.sh kde   # or xfce, gnome
```

Full steps in [docs/new-vm.md](docs/new-vm.md).

## 🔁 Day to day

```bash
sudo nixos-rebuild switch --flake path:$HOME/nix-vm#kde --impure
```

- 🔎 Type the start of a command and press ↑/↓ to cycle through matching history.
- ❄️ `nd`: enter a project's `nix develop` with zsh; a snowflake badge shows in the prompt.
- ✍️ Doom and p10k configs live in `config/`: edit, commit, push.

## 📚 Docs

- [New VM](docs/new-vm.md)
- [Decisions](docs/decisions.md)
