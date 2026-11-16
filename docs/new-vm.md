# 🆕 New VM

## 1. Create the VM in VirtualBox

- 🥾 Firmware: BIOS (leave **Enable EFI** off)
- 💾 Disk: SATA, 40 GB or more (installed to `/dev/sda`)
- 🖼️ Graphics: VMSVGA (default)
- 🛡️ Shared clipboard and drag and drop: **Disabled**; no shared folders
- 💿 Boot the [NixOS minimal ISO](https://nixos.org/download/)

## 2. Install

```bash
curl -LO https://raw.githubusercontent.com/landoicco/nix-vm/main/install.sh
less install.sh
sudo bash install.sh kde   # or xfce, gnome
```

It erases `/dev/sda`, installs the chosen desktop and asks for your password.
Remove the ISO and reboot.

## 3. First login

```bash
doom install
```

## 🔁 Rebuild and update

```bash
sudo nixos-rebuild switch --flake path:$HOME/nix-vm#kde --impure
nix flake update --flake path:$HOME/nix-vm   # then rebuild
```

## 🗑️ Delete

Push your changes to `config/` first, then delete the VM in VirtualBox.
