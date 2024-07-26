{ config, pkgs, lib, osConfig, ... }:
{
  # Base configuration for any MacOS machine I use
  # To be used in conjunction with hm-base.nix

  home.packages = [
    pkgs.iina
  ];

  home.shellAliases = {
    # This assumes this repo is in ~/.nixpkgs
    drs = "darwin-rebuild switch --flake ~/.nixpkgs";
    # TODO: package makemkv
    maybe-makemkvcon = "/Applications/MakeMKV.app/Contents/MacOS/makemkvcon";
  };

  programs.fish = {
    functions = {
      legacy-brew-init = ''
        # Initializes brew in fish, as was done in ~/.zprofile
        # This function is defined in home-yuto.nix
        /opt/homebrew/bin/brew shellenv | source
      '';
    };

    # HACK: See https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635 and https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1666623924
    loginShellInit =
      let
        # This naive quoting is good enough in this case. There shouldn't be any
        # double quotes in the input string, and it needs to be double quoted in case
        # it contains a space (which is unlikely!)
        dquote = str: "\"" + str + "\"";

        makeBinPathList = map (path: path + "/bin");
      in ''
        fish_add_path --move --prepend --path ${lib.concatMapStringsSep " " dquote (makeBinPathList osConfig.environment.profiles)}
        set fish_user_paths $fish_user_paths
      '';
  };
}