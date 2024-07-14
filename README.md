# venus

Another attempt at using nix-darwin and home-manager on macOS.

## Usage

Run `darwin-rebuild switch --flake ~/.nixpkgs` where `~/.nixpkgs` is the cloned local copy of this repo, to apply this repo's configs.

### Tide

Tide is a fish prompt plugin. It does not generate a dotfile; instead, it sets fish's "universal variables". The current prompt can be re-set with this command:

```fish
tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Slanted --powerline_prompt_heads=Slanted --powerline_prompt_tails=Flat --powerline_prompt_style='One line' --prompt_spacing=Compact --icons='Many icons' --transient=No
```

## My Notes
- Think of nix-darwin as NixOS's `/etc/nixos/configuration.nix` but for macOS
- home-manager is installed as a module under nix-darwin so that I don't have 2 separate commands for applying the nix configs

## Structure
- `legacy-yadm/` contains copies of dotfiles from the old dotfiles repo back when it was managed by yadm