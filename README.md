# venus

Another attempt at using nix-darwin and home-manager on macOS.

## Usage

Run `darwin-rebuild switch --flake ~/.nixpkgs` where `~/.nixpkgs` is the cloned local copy of this repo, to apply this repo's configs.

## My Notes
- Think of nix-darwin as NixOS's `/etc/nixos/configuration.nix` but for macOS
- home-manager is installed as a module under nix-darwin so that I don't have 2 separate commands for applying the nix configs
