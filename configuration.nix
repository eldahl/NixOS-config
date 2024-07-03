# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
      			./hardware-configuration.nix
			inputs.home-manager.nixosModules.default
		];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-0d07dc1d-0df5-41cd-bcdf-64954493b2df".device = "/dev/disk/by-uuid/0d07dc1d-0df5-41cd-bcdf-64954493b2df";
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-daa6f869-d6f4-4090-a639-ccc2b0cc306c".keyFile = "/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-0d07dc1d-0df5-41cd-bcdf-64954493b2df".keyFile = "/crypto_keyfile.bin";
  	
	# Disable password prompt for sudo commands
	security.sudo.extraRules= [{  
		users = [ "ebber" ];
    		commands = [
       			{
	 			command = "ALL" ;
         			options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
      			}
    		];
  	}];

	networking.hostName = "desktop"; # Define your hostname.
  	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Enable networking and set dns servers to cloudflare
	networking.networkmanager.enable = true;
	networking.dhcpcd.extraConfig = "nohook resolv.conf";
	networking.networkmanager.dns = "none";
	networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

	# Wake on lan for main interface
	networking.interfaces.eno1.wakeOnLan.enable = true;
  
	networking.firewall = {
	  enable = true;
	  allowedTCPPorts = [ 3000 ];
	  #allowedUDPPortsRanges = [
	  #  { from = 4000; to = 4008; }
	  #  { from = 8000; to = 8010; }
	  #];
	};

	
	# Set your time zone.
	time.timeZone = "Europe/Copenhagen";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_DK.UTF-8";

	i18n.extraLocaleSettings = {
	LC_ADDRESS = "da_DK.UTF-8";
	LC_IDENTIFICATION = "da_DK.UTF-8";
	LC_MEASUREMENT = "da_DK.UTF-8";
	LC_MONETARY = "da_DK.UTF-8";
	LC_NAME = "da_DK.UTF-8";
	LC_NUMERIC = "da_DK.UTF-8";
	LC_PAPER = "da_DK.UTF-8";
	LC_TELEPHONE = "da_DK.UTF-8";
	LC_TIME = "da_DK.UTF-8";
	};

	# Configure console keymap
	console.keyMap = "dk-latin1";

	hardware.keyboard.zsa.enable = true;

	# Enable CUPS to print documents.
	services.printing.enable = true;
	
	# Enable the KDE Plasma Desktop Environment.
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;

	# Configure keymap in X11
	services.xserver = {
		xkb.layout = "dk";
		xkb.variant = "";
	};

  	# Enable the X10 windowing system.
  	# You can disable this if you're only using the Wayland session.
  	services.xserver.enable = true;
	
	# NVIDIA Driver
	hardware.opengl = {
		enable = true;
	};
	services.xserver.videoDrivers = ["nvidia"];
	hardware.nvidia = {
		
		modesetting.enable = true;

		powerManagement.enable = true;
		powerManagement.finegrained = false;

		open = false;

		nvidiaSettings = true;

		#package = config.boot.kernelPackages.nvidiaPackages.stable;
		package = config.boot.kernelPackages.nvidiaPackages.beta;

	};

	# Enable sound with pipewire.
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	# If you want to use JACK applications, uncomment this
	#jack.enable = true;

	# use the example session manager (no others are packaged yet so this is enabled by default,
	# no need to redefine it in your config for now)
	#media-session.enable = true;
	};

	# Enable touchpad support (enabled default in most desktopManager).
	# services.xserver.libinput.enable = true;
	programs.steam = {
		enable = true;
	};
  	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.ebber = {
		isNormalUser = true;
		description = "ebber";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [
			kdePackages.kate
			kdePackages.kalk
			thunderbird
			
			chromium
			vscodium
			
			element-desktop
			signal-desktop

			webcord
			#vesktop

			spotify

			bitwarden-desktop
			
			obsidian

			obs-studio

			dig
			ldns
			runelite
			protonup-qt
		];
	};

	services.ollama = {
	  enable = true;
	  acceleration = "cuda";
	};


  	# Install firefox.
  	programs.firefox.enable = true;

  	# Allow unfree packages
  	nixpkgs.config.allowUnfree = true;

  	# List packages installed in system profile. To search, run:
  	# $ nix search wget
  	environment.systemPackages = with pkgs; [
		keymapp
		zsa-udev-rules
		neovim
		xclip
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  		wget
		git
		gh
		htop
		openvpn

		wine64
		winetricks
		bottles

		syncthing
		syncthingtray

		# Development tools/libraries
		clang
		clang-tools
		nodejs_22
		freeglut
	];

	environment.pathsToLink = ["/share/bash-completion"];

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "24.05"; # Did you read the comment?
  
  	nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
