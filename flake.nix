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
    #homeConfigurations."main" = home-manager.lib.homeManagerConfiguration {
    #  pkgs = nixpkgs;
    #  modules = [
    #    ./home-yuto.nix
    #  ];
    #};
    homeManagerPartial."base" = import ./hm-base.nix;
    homeManagerPartial."macos" = import ./hm-macos.nix;
    homeManagerPartial."main" = import ./hm-personal-main.nix;
    darwinConfigurations."Yutos-Magnesium-Chloride" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
        {
          #nixpkgs.overlays = [ inputs.nixpkgs-firefox-darwin.overlay ];
          home-manager.useGlobalPkgs = true;
          #home-manager.useUserPackages = true; # This breaks fish??
          home-manager.users.yuto = {
            imports = [
              self.homeManagerPartial."base"
              self.homeManagerPartial."macos"
            ];
          };
        }
      ];
    };
    darwinConfigurations."Yutos-Sodium" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
        {
          #nixpkgs.overlays = [ inputs.nixpkgs-firefox-darwin.overlay ];
          home-manager.useGlobalPkgs = true;
          #home-manager.useUserPackages = true; # This breaks fish??
          home-manager.users.yuto = {
            imports = [
              self.homeManagerPartial."base"
              self.homeManagerPartial."macos"
              self.homeManagerPartial."main"
            ];
          };
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
      ];
    };
  };
}
