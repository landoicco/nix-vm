# 📖 Guide

## 1. 🆕 Create the VM in VirtualBox

- 🥾 Firmware: BIOS (leave **Enable EFI** off)
- 🧠 RAM: 4 GB or more
- 💾 Disk: SATA, 40 GB or more (installed to `/dev/sda`)
- 🖼️ Graphics: VMSVGA (default)
- 🌐 Network: NAT (default)
- 🛡️ Shared clipboard and drag and drop: **Disabled**; no shared folders
- 💿 Optical drive: the [NixOS minimal ISO](https://nixos.org/download/)

## 2. 💿 Install

Boot the ISO; it logs you in as `nixos` with network already up. Then:

```bash
curl -LO https://raw.githubusercontent.com/landoicco/nix-vm/main/install.sh
less install.sh            # read it first: it erases /dev/sda
sudo bash install.sh kde   # or xfce, gnome
```

The script:

1. Checks the desktop name, BIOS boot and that `/dev/sda` is not in use.
2. Asks you to type `YES` before erasing `/dev/sda`.
3. Creates the root partition and 4 GiB of swap.
4. Clones this repo to `~/nix-vm` and Doom Emacs to `~/.config/emacs`.
5. Installs NixOS with the chosen desktop.
6. Asks for your user password (root has none; use `sudo`).

Then power off, remove the ISO from the VM and boot it.

## 3. 👋 First login

```bash
doom install   # accept the defaults; your config in config/doom is kept
```

## 4. 🔁 Day to day

Apply changes to the repo (use the desktop you installed):

```bash
sudo nixos-rebuild switch --flake path:$HOME/nix-vm#kde --impure
```

Update packages to the latest stable, then rebuild:

```bash
nix flake update --flake path:$HOME/nix-vm
```

- ❄️ `nd`: open a project's `nix develop` with zsh; a snowflake badge shows in the prompt.
- 🔎 Type the start of a command and press ↑/↓ to cycle through matching history.
- ✍️ Doom config lives in `~/nix-vm/config/doom`; run `doom sync` after editing
  `init.el` or `packages.el`.
- 📥 Get the latest repo changes: `git -C ~/nix-vm pull`, then rebuild.

## 5. 🗑️ Delete

Delete the VM in VirtualBox. VMs only consume this repo, so local edits are
lost; make lasting changes in the repo itself.
