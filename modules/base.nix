# Shared by every VM, whatever the desktop.
{ pkgs, ... }:

{
  # VirtualBox BIOS default; install.sh partitions this disk
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.configurationLimit = 5;

  networking.hostName = "nix-vm";
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
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # Makes zsh a valid login shell; its config lives in home.nix
  programs.zsh.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    vscode
    brave
    # CLI basics missing from a default NixOS
    zip
    unzip
    htop
    tree
    jq
    file
  ];

  # Powerlevel10k's recommended font
  fonts.packages = [ pkgs.meslo-lgs-nf ];

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

  system.stateVersion = "26.05";
}
