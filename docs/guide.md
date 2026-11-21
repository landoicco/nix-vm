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

It asks for the desktop and hostname, asks you to type `YES` before erasing
`/dev/sda`, installs, and asks for your password (root has none; use `sudo`).
Then power off, remove the ISO from the VM and boot it.

### 🧪 Testing a branch

To install from a branch before merging it, take both the script and the
flake from that branch:

```bash
curl -LO https://raw.githubusercontent.com/landoicco/nix-vm/<branch>/install.sh
sudo NIX_VM_REPO='github:landoicco/nix-vm?ref=<branch>' bash install.sh
```

`<branch>` can also be a tag, e.g. `v1.1.0`. The VM's flake keeps following
it; see "Follow the repo" below to point it back to `main`.

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

- 🖼️ Wallpaper: run `nitrogen` (`Mod+d`), add a folder and pick an image with
  **Zoomed Fill**; it stays across logins.
- 📁 Files: `pcmanfm`. There is no trash: deleting is for good.
- 🎨 polybar colors are Gruvbox; change any of `bg`, `surface`, `fg`,
  `muted`, `dim` or `accent` in `configuration.nix`, e.g.
  `nix-vm.polybar.colors.accent = "#83a598";`.

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
- 🤖 AI tools are off by default: uncomment their line and rebuild. For
  Claude Code, run `claude` and log in; its config is copied to `~/.claude` once.
- Something broke? Pick an older generation in GRUB, or run
  `sudo nixos-rebuild switch --rollback`.

### 📥 Follow the repo

Get the latest nix-vm (and the nixpkgs it pins), then rebuild:

```bash
sudo nix flake update nix-vm --flake /etc/nixos
sudo nixos-rebuild switch
sudo git -C /etc/nixos commit -am "Update nix-vm"
```

To follow another branch, set `inputs.nix-vm.url` in `/etc/nixos/flake.nix`
and run the same commands:

```nix
inputs.nix-vm.url = "github:landoicco/nix-vm?ref=<branch>";
```

Once it is merged, go back to `github:landoicco/nix-vm`. With a tag
(`?ref=v1.1.0`), updates stay on that release until you change it. The VM
only sees commits already pushed to GitHub.

On i3, log out and back in (`Mod+Shift+e`) after a rebuild that changes the
i3 or polybar config.

### 💡 Tips

- 🧊 `nd`: open a project's `nix develop` with zsh; an ice cube shows in the prompt.
- 🔎 Type the start of a command and press ↑/↓ to cycle through matching history.
- ✍️ Edit Doom in `~/.config/doom`; run `doom sync` after changing `init.el`
  or `packages.el`.

## 5. 🛠️ Change the repo

Work in your own clone, never from a VM:

- 🧩 New tool for every VM: a module in `modules/features` with its
  `nix-vm.<name>.enable` option, turned on in `profiles/development.nix`.
- 📝 Doom, p10k or Claude Code changes worth keeping: copy them from a VM to
  `config/` by hand.
- 🔄 Update pinned packages: `nix flake update`; only Claude Code and Cursor:
  `nix flake update nixpkgs-unstable`.
- ✅ Before committing: `nix flake check --no-build "path:$PWD"`. CI runs
  the same check on every pull request and push to `main`.

VMs only see the change once they follow the repo.

## 6. 🗑️ Delete

Delete the VM in VirtualBox. Anything in its `/etc/nixos` worth keeping
belongs in the repo first.
