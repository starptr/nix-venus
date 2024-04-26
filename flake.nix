{
  description = "Yuto's darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, home-manager, nix-darwin, nixpkgs, ... }: {
    darwinConfigurations."Yutos-Sodium" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        {
          nixpkgs.overlays = [ inputs.nixpkgs-firefox-darwin.overlay ];
          home-manager.useGlobalPkgs = true;
          home-manager.users.yuto = import ./home-yuto.nix;
          # {
          #   # home.nix
          #   programs.firefox = {
          #     enable = true;

          #     # IMPORTANT: use a package provided by the overlay (ends with `-bin`)
          #     # see overlay.nix for all possible packages
          #     package = nixpkgs.firefox-bin; # Or pkgs.librewolf if you're using librewolf
          #   };
          #   home.stateVersion = "23.11";
          # };
        }
        ./darwin-configuration.nix
      ];
    };
  };
}
