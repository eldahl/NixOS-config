{
	description = "My First Flake!";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		stylix.url = "github:danth/stylix";
		stylix.inputs = {
			nixpkgs.follows = "nixpkgs";
			home-manager.follows = "home-manager";
		};
		base16.url = "github:SenchoPens/base16.nix";
		tt-schemes = {
		    url = "github:tinted-theming/schemes";
		    flake = false;
		};
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, nur, ... }@inputs: 
	let 
		lib = nixpkgs.lib;
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
	in {
		packages.${system} = {
			vesktopIcon = pkgs.callPackage ./config/vesktop.nix {};
		};
		nixosConfigurations = {
			desktop = lib.nixosSystem {
				inherit system;
				specialArgs = {inherit inputs;};
				modules = [ 
					./configuration.nix
					inputs.stylix.nixosModules.stylix
					inputs.base16.nixosModule
					{ scheme = "${inputs.tt-schemes}/base16/woodland.yaml"; }
					home-manager.nixosModules.home-manager {
						home-manager.users.ebber = import ./home.nix;
						home-manager.backupFileExtension = "bak";
						home-manager.sharedModules = [{ 
						  #stylix.targets.kde.enable = true; 
						  #stylix.targets.kitty.enable = true;
						}];
					}
				];
			};
		};
	};
}
