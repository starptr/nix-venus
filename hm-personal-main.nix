{ config, pkgs, lib, osConfig, ... }:
{
  # Personal tools for my daily drivers (eg. Sodium)
  # Currently assumes a darwin system and using both hm-base and hm-macos

  programs.mpv = {
    enable = true;
    package = pkgs.mpv-unwrapped.wrapper {
      mpv = pkgs.mpv-unwrapped.override {
        ffmpeg = pkgs.ffmpeg-full;
      };
    };
  };

  programs.ssh = {
    extraConfig = builtins.readFile ./configs/ssh.txt;
  };
}