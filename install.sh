#!/usr/bin/env bash
# Installs a nix-vm VM from the NixOS minimal ISO, erasing the whole disk.
# Usage: sudo bash install.sh [xfce|kde|gnome|i3]
# Asks for the desktop when not given, and for the hostname.
# NIX_VM_REPO picks another flake ref, e.g. to test a branch:
#   sudo NIX_VM_REPO='github:landoicco/nix-vm?ref=my-branch' bash install.sh kde
set -euo pipefail

repo=${NIX_VM_REPO:-github:landoicco/nix-vm}
doom_url=https://github.com/doomemacs/doomemacs
disk=/dev/sda
user=licaza
desktops=(xfce kde gnome i3)
desktop=${1:-}

die() {
  echo "error: $*" >&2
  exit 1
}

# Progress in NixOS light blue (bright cyan on the ISO console)
step() {
  if [[ -t 1 ]]; then
    printf '\e[1;96m==> %s\e[0m\n' "$*"
  else
    printf '==> %s\n' "$*"
  fi
}

[[ $EUID -eq 0 ]] || die "run as root (sudo)"
[[ ! -d /sys/firmware/efi ]] || die "UEFI detected; disable EFI in the VM settings"
[[ -b $disk ]] || die "$disk not found"
# Refuse to touch a disk in use, e.g. when run on an installed VM instead of the ISO
! lsblk -no MOUNTPOINTS "$disk" | grep -q . || die "$disk is in use; run this from the NixOS ISO"

if [[ -z $desktop ]]; then
  echo "Desktop:"
  PS3="Choose [1-${#desktops[@]}]: "
  select desktop in "${desktops[@]}"; do
    [[ -n $desktop ]] && break
  done
fi
[[ " ${desktops[*]} " == *" $desktop "* ]] || die "unknown desktop '$desktop'; pick one of: ${desktops[*]}"

while true; do
  read -rp "Hostname [nix-vm]: " hostname
  hostname=${hostname:-nix-vm}
  # One DNS label: lowercase letters, digits and inner hyphens
  [[ $hostname =~ ^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$ ]] && break
  echo "Use lowercase letters, digits and hyphens (not at the start or end)."
done

echo "Desktop: $desktop, hostname: $hostname"
read -rp "This erases everything on $disk. Type YES to continue: " answer
[[ $answer == YES ]] || die "aborted"

export NIX_CONFIG="experimental-features = nix-command flakes"
PATH="$(nix-build '<nixpkgs>' -A git --no-out-link)/bin:$PATH"
git_commit() { git -c user.name=nix-vm -c user.email=nix-vm@localhost commit -qm "$1"; }

step "Creating this VM's flake ($desktop)"
config=$(mktemp -d)
nix flake new -t "$repo" "$config/nixos"
config=$config/nixos
sed -i \
  -e "s|desktop = \"kde\";|desktop = \"$desktop\";|" \
  -e "s|hostname = \"nix-vm\";|hostname = \"$hostname\";|" \
  -e "s|inputs.nix-vm.url = \".*\";|inputs.nix-vm.url = \"$repo\";|" \
  "$config/flake.nix"
# Disks come from disko, so only the detected hardware is kept
nixos-generate-config --no-filesystems --show-hardware-config >"$config/hardware-configuration.nix"
# A git flake only sees tracked files; locking before the install keeps
# the flake from changing while Nix reads it
git -C "$config" init -q
git -C "$config" add -A
nix flake lock "$config"
git -C "$config" add flake.lock
(cd "$config" && git_commit "Initial configuration from nix-vm")

step "Partitioning $disk"
nix run --inputs-from "$config" nix-vm#disko -- \
  --mode destroy,format,mount --yes-wipe-all-disks --flake "$config#$hostname"

step "Installing NixOS"
mkdir -p /mnt/etc
cp -a "$config" /mnt/etc/nixos
nixos-install --no-root-passwd --flake "/mnt/etc/nixos#$hostname"

step "Setting up $user's home"
home=/mnt/home/$user
src=$(nix eval --raw --impure --expr "(builtins.getFlake \"git+file:///mnt/etc/nixos\").inputs.nix-vm.outPath")
mkdir -p "$home/.config"
git clone -q --depth 1 "$doom_url" "$home/.config/emacs"
# Plain copies: edit them freely, Nix does not manage them
cp -r --no-preserve=mode "$src/config/doom" "$home/.config/doom"
cp --no-preserve=mode "$src/config/p10k.zsh" "$home/.p10k.zsh"
nixos-enter --root /mnt -c "chown -R $user:users /home/$user && passwd $user"

step "Done. Remove the ISO, reboot, log in and run: doom install"
