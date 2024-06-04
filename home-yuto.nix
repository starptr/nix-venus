{ config, pkgs, lib, osConfig, ... }:

let
  my-emacs = pkgs.emacs29-macport.override {};
  my-emacs-with-packages = (pkgs.emacsPackagesFor my-emacs).emacsWithPackages (epkgs: [
    epkgs.vterm
  ]);
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  #home.username = "yuto";
  #home.homeDirectory = "/Users/yuto";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.fd

    pkgs.ripgrep

    pkgs.emacs-all-the-icons-fonts

    # Don't add project-local binaries to global userspace!!
    # pkgs.morph

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/yuto/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.shellAliases = {
    # This assumes this repo is in ~/.nixpkgs
    drs = "darwin-rebuild switch --flake ~/.nixpkgs";
  };

  programs.fish = {
    enable = true;
    functions = {
      d = ''
        if [ "$PWD" = "$HOME/Downloads" ]
          ${pkgs.lsd}/bin/lsd -A --sort time $argv
        else
          ${pkgs.lsd}/bin/lsd -A $argv
        end
      '';
      da = ''
        if [ "$PWD" = "$HOME/Downloads" ]
          ${pkgs.lsd}/bin/lsd -Alr --sort time $argv
        else
          ${pkgs.lsd}/bin/lsd -Al $argv
        end
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

  programs.direnv = {
    enable = true;
    # Fish integration is automatically enabled
    nix-direnv = {
      enable = true;
    };
  };

  programs.firefox = {
    enable = false;

    package = pkgs.firefox-bin;
  };

  programs.emacs = {
    enable = false;
    package = my-emacs-with-packages;
  };

  programs.yt-dlp = {
    enable = true;
  };

  programs.git = {
    enable = true;
    #package = pkgs.git # Use the system git, as it contains Apple-specific patches (TODO: are they important?)
    delta = {
      enable = true;
    };
    includes = [
      {
        # Include the following in an emergency to use git with the old working configuration
        # TODO: Remove this after implementing the config directly in `programs.git.extraConfig`
        path = ./legacy-yadm/git-config.txt;
      }
    ];
    userEmail = "yuto@berkeley.edu";
    userName = "Yuto Nishida";
  };

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
