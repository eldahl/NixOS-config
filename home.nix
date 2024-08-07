{ inputs, lib, config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ebber";
  home.homeDirectory = "/home/ebber";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

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
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ebber/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";

  };

  programs.kitty = lib.mkForce {
    enable = true;
    font = {
      name = "LiterationMono Nerd Font";
      size = 9.5;

    };
    settings = {
      confirm_os_window_close = 0;
      background_image = "~/.dotfiles/console.png";
      background_image_layout = "cscaled";
      dynamic_background_opacity = true;
      enable_audio_bell = true;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_opacity = "0.7";
      background_blur = 5;
      symbol_map = let
	mappings = [
	  "U+23FB-U+23FE"
	  "U+2B58"
	  "U+E200-U+E2A9"
	  "U+E0A0-U+E0A3"
	  "U+E0B0-U+E0BF"
	  "U+E0C0-U+E0C8"
	  "U+E0CC-U+E0CF"
	  "U+E0D0-U+E0D2"
	  "U+E0D4"
	  "U+E700-U+E7C5"
	  "U+F000-U+F2E0"
	  "U+2665"
	  "U+26A1"
	  "U+F400-U+F4A8"
	  "U+F67C"
	  "U+E000-U+E00A"
	  "U+F300-U+F313"
	  "U+E5FA-U+E62B"
	];
      in
	(builtins.concatStringsSep "," mappings) + " LiterationMono Nerd Font";
    };
  };

  programs.starship = {
    enable = true;
    settings = {

    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/ebber/.dotfiles/ --impure";
      hidemyass = "sudo openvpn ~/Downloads/AirVPN_Norway_TCP-443-Entry3.ovpn";
    };
    bashrcExtra = ''
      eval "$(starship init bash)"\n
    '';
  };

  programs.git = {
    enable = true;
    userName = "Eldahl";
    userEmail = "71466904+eldahl@users.noreply.github.com";
  };
}
