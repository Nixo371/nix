{
  description = "NicOX";

  inputs = {
    # === Nix Packages collection ===
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # === Hyprland ===
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # === Home Manager ===
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprland-plugins, zen-browser }@inputs:
    let
      systemName = "forge";
      username = "nucieda";
      systemArch = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${systemArch};
    in {
      nixosConfigurations = {
        "${systemName}" = nixpkgs.lib.nixosSystem {
          system = systemArch;
          specialArgs = { inherit inputs username; };
          modules = [
            ./nixos/${systemName}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs username; };
              home-manager.users.${username} = import ./home/${username}/home.nix;
            }
          ];
        };
      };

      homeConfigurations = {
        "${username}@${systemName}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs username; };
          modules = [ ./home/${username}/home.nix ];
        };
      };
    };
}
