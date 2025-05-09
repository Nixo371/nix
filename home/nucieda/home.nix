{ config, pkgs, inputs, username, ... }: {
  # === Basic Home Manager Settings ===
  home.username = "nucieda";
  home.homeDirectory = "/home/${username}";
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.11";

  # === Packages ===
  home.packages = with pkgs; [
    # Terminals
    ghostty

    # Dev tools
    vscode
    neovim
    helix

    # Languages + Compilers
    gcc
    go

    # LSPs
    bear
    clang-tools
    gopls

    # Shell
    nushell
    nushellPlugins.highlight
    zsh
    oh-my-zsh

    # Command Line Tools
    ripgrep

    # Misc software
    neofetch
    spacedrive
    inputs.zen-browser.packages."${pkgs.system}".default
    vesktop

    # Hyprland Addons
    hyprpaper
    hyprlandPlugins.hyprexpo
    hyprcursor
    walker
  ];

  # Hyprland Configuration
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
  };

  # === Dotfile Management ===
  home.file = {
    ".oh-my-zsh" = {
      source = ./dotfiles/oh-my-zsh;
      recursive = true;
    };
  };

  # === Program Configurations ===
  programs.git = {
    enable = true;
  };

  programs.home-manager ={
    enable = true;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };
}
