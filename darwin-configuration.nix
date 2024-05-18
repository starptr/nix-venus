{ config, pkgs, ... }:

# This file is the equivalent of /etc/nixos/configuration.nix on darwin
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
	pkgs.nix-info
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  services.yabai = {
    enable = true;
  };

  security.pam.enableSudoTouchIdAuth = true;

  # nix.package = pkgs.nix;
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];

    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "x86_64.nix.yuto.sh";
        sshUser = "yuto";
        system = "x86_64-linux";
      }
    ];
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # For nix-darwin
  nixpkgs.hostPlatform = "aarch64-darwin";

  # User info
  users.users."yuto" = {
    name = "yuto";
    home = "/Users/yuto";
    shell = pkgs.fish;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
