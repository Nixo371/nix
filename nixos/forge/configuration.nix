{ config, pkgs, inputs, username, lib, ... }: 

{
  # === Hardware Imports ===
  imports = [ ./hardware-configuration.nix ];

  # === Basic System Setup ===
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "forge";
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";

  # === User Account ===
  users.users.${username} = {
    isNormalUser = true;
    description = "System admin";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    shell = pkgs.zsh;
  };

  # === Nix Settings ===
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # === Greetd config ===
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${lib.getExe pkgs.hyprland}";
        user = username;
      };
      default_session = {
        command = "${lib.getExe' pkgs.greetd.greetd "agreety"} --cmd ${lib.getExe pkgs.hyprland}";
      };
    };
  };

  # === System Packages ===
  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    hyprland
    hyprpolkitagent
    xdg-desktop-portal-hyprland
  ];

  # === System Settings ===
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  };

  # === Programs and Services ===
  programs.hyprland.enable = true;

  programs.zsh.enable = true;

  security.polkit.enable = true;

  services.openssh.enable = true;

  # === System ===
  system.stateVersion = "23.11";
}
