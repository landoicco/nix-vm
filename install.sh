#!/usr/bin/env bash
# Installs a nix-vm VM from the NixOS minimal ISO, erasing the whole disk.
# Usage: sudo bash install.sh <xfce|kde|gnome>
set -euo pipefail

repo_url=https://github.com/landoicco/nix-vm
doom_url=https://github.com/doomemacs/doomemacs
disk=/dev/sda
user=licaza
desktop=${1:-}

die() {
  echo "error: $*" >&2
  exit 1
}

case $desktop in
  xfce | kde | gnome) ;;
  *) die "usage: sudo bash install.sh <xfce|kde|gnome>" ;;
esac
[[ $EUID -eq 0 ]] || die "run as root (sudo)"
[[ ! -d /sys/firmware/efi ]] || die "UEFI detected; disable EFI in the VM settings"
[[ -b $disk ]] || die "$disk not found"
# Refuse to touch a disk in use, e.g. when run on an installed VM instead of the ISO
! lsblk -no MOUNTPOINTS "$disk" | grep -q . || die "$disk is in use; run this from the NixOS ISO"

read -rp "This erases everything on $disk. Type YES to continue: " answer
[[ $answer == YES ]] || die "aborted"

echo "==> Partitioning $disk (root + 4 GiB swap)"
parted -s "$disk" -- mklabel msdos \
  mkpart primary ext4 1MiB -4GiB \
  set 1 boot on \
  mkpart primary linux-swap -4GiB 100%
udevadm settle
mkfs.ext4 -F -L nixos "${disk}1"
mkswap -L swap "${disk}2"
mount "${disk}1" /mnt
swapon "${disk}2"

echo "==> Generating hardware config"
nixos-generate-config --root /mnt
# The flake replaces configuration.nix; only the hardware config is used
rm /mnt/etc/nixos/configuration.nix
# The flake reads /etc/nixos, which on the ISO belongs to the live system
mkdir -p /etc/nixos
cp /mnt/etc/nixos/hardware-configuration.nix /etc/nixos/

echo "==> Cloning nix-vm and Doom Emacs"
home=/mnt/home/$user
mkdir -p "$home/.config"
nix-shell -p git --run "git clone $repo_url $home/nix-vm && git clone --depth 1 $doom_url $home/.config/emacs"

echo "==> Installing NixOS ($desktop)"
# path: makes Nix keep this VM's own flake.lock, which git ignores
NIX_CONFIG="experimental-features = nix-command flakes" \
  nixos-install --no-root-passwd --impure --flake "path:$home/nix-vm#$desktop"

echo "==> Setting the password for $user"
nixos-enter --root /mnt -c "chown -R $user:users /home/$user && passwd $user"

echo "Done. Remove the ISO, reboot, log in and run: doom install"
