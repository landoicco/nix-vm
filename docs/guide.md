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
less install.sh         # read it first: it erases /dev/sda
sudo bash install.sh    # or skip the desktop menu: sudo bash install.sh kde
```

The script:

1. Checks BIOS boot and that `/dev/sda` is not in use.
2. Asks for the desktop (xfce, kde, gnome or i3) and the hostname
   (`nix-vm` by default).
3. Asks you to type `YES` before erasing `/dev/sda`.
4. Creates this VM's flake from the template, with its desktop, hostname
   and hardware config, and commits it to a local git repo.
5. Partitions the disk with disko: GRUB boot, root and 4 GiB of swap.
6. Installs NixOS from that flake, which ends up in `/etc/nixos`.
7. Clones Doom Emacs to `~/.config/emacs` and copies the Doom and p10k
   configs to `~/.config/doom` and `~/.p10k.zsh`.
8. Asks for your user password (root has none; use `sudo`).

Then power off, remove the ISO from the VM and boot it.

### 🧪 Testing a branch

To install from a branch before merging it, take both the script and the
flake from that branch:

```bash
curl -LO https://raw.githubusercontent.com/landoicco/nix-vm/<branch>/install.sh
sudo NIX_VM_REPO='github:landoicco/nix-vm?ref=<branch>' bash install.sh
```

The VM's flake keeps following that branch. Once it is merged, point it
back to `main` (see "Follow the repo" below).

## 3. 👋 First login

```bash
doom install   # accept the defaults; your config in ~/.config/doom is kept
```

### 🪟 i3

The i3 config comes from home-manager, with **Win** as the modifier
(`Mod`). The keys you need:

| Key               | Action                                    |
|-------------------|-------------------------------------------|
| `Mod+Enter`       | Open a terminal (Alacritty)               |
| `Mod+d`           | Launch an app (dmenu)                     |
| `Mod+Shift+q`     | Close the window                          |
| `Mod+1…9`         | Go to workspace 1–9                       |
| `Mod+Shift+1…9`   | Move the window to workspace 1–9          |
| `Mod+arrows`      | Move between windows                      |
| `Mod+h` / `Mod+v` | Open the next window beside / below       |
| `Mod+e`           | Switch the split between beside and below |
| `Mod+w`           | Tabs: one window at a time                |
| `Mod+f`           | Fullscreen on and off                     |
| `Mod+Shift+e`     | Log out                                   |

New windows share the screen: three terminals on one workspace show side
by side.

To set a wallpaper, run `nitrogen` (`Mod+d`, then type it), add a folder
of images and pick one with **Zoomed Fill**. It comes back on each login
and redraws when the VM window is resized.

polybar shows the workspaces, the window title, CPU, memory, disk, IP and
the clock. Its colors are Gruvbox; change any of them in the VM's
`configuration.nix`:

```nix
nix-vm.polybar.colors.accent = "#83a598";
```

The others are `bg`, `surface`, `fg`, `muted` and `dim`.

## 4. 🔁 Day to day

`/etc/nixos` holds this VM's configuration:

```
/etc/nixos/
  flake.nix                    # development profile, desktop and hostname
  flake.lock                   # pinned nix-vm and nixpkgs versions
  hardware-configuration.nix   # generated at install
  configuration.nix            # this VM's own changes
```

### ✍️ Change this VM

```bash
sudo -e /etc/nixos/configuration.nix
sudo nixos-rebuild switch
sudo git -C /etc/nixos commit -am "Add btop"
```

- A new file in `/etc/nixos` needs `sudo git -C /etc/nixos add <file>`;
  Nix ignores untracked files.
- Turn off a feature of the profile with, e.g., `nix-vm.docker.enable = false;`.
- Something broke? Pick an older generation in GRUB, or run
  `sudo nixos-rebuild switch --rollback`.

### 📥 Follow the repo

Get the latest nix-vm (and the nixpkgs it pins), then rebuild:

```bash
sudo nix flake update nix-vm --flake /etc/nixos
sudo nixos-rebuild switch
sudo git -C /etc/nixos commit -am "Update nix-vm"
```

To follow another branch, edit `inputs.nix-vm.url` in `/etc/nixos/flake.nix`
and run the same commands.

### 💡 Tips

- ❄️ `nd`: open a project's `nix develop` with zsh; a snowflake badge shows in the prompt.
- 🔎 Type the start of a command and press ↑/↓ to cycle through matching history.
- ✍️ Edit Doom in `~/.config/doom`; run `doom sync` after changing `init.el`
  or `packages.el`.

## 5. 🛠️ Change the repo

Work in your own clone, never from a VM:

- 🧩 New tool for every VM: a module in `modules/features` with its
  `nix-vm.<name>.enable` option, turned on in `profiles/development.nix`.
- 📝 Doom or p10k changes worth keeping: copy them from a VM to `config/` by hand.
- 🔄 Update pinned packages: `nix flake update`.
- ✅ Before committing: `nix flake check --no-build "path:$PWD"`. CI runs
  the same check on every pull request and push to `main`.

VMs only see the change once they follow the repo.

## 6. 🗑️ Delete

Delete the VM in VirtualBox. Anything in its `/etc/nixos` worth keeping
belongs in the repo first.
