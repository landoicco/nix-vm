# Shared by every VM, whatever the profile or desktop.
{ lib, pkgs, ... }:

{
  imports = [
    ./disk.nix
    ./features/cli.nix
    ./features/docker.nix
    ./features/emacs.nix
    ./features/git.nix
    ./features/gui-apps.nix
    ./features/zsh.nix
  ];

  # VirtualBox BIOS default; disk.nix sets the disk GRUB installs to
  boot.loader.grub.enable = true;
  boot.loader.grub.configurationLimit = 5;

  # Each VM's flake sets its own
  networking.hostName = lib.mkDefault "nix-vm";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb.layout = "us";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # The password is set with passwd during install; never in this repo
  users.users.licaza = {
    isNormalUser = true;
    description = "Lando Icaza";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Features add their user settings under home-manager.users.licaza
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Documents, Downloads and the rest; no desktop creates them on NixOS
  home-manager.users.licaza.xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Color emoji instead of Symbola's monochrome ones
  fonts.packages = [ pkgs.noto-fonts-color-emoji ];
  fonts.fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];

  # Same cursor on every desktop
  home-manager.users.licaza.home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Keeps the VM disk from filling up with old generations
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
