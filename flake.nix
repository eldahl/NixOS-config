{
	description = "My First Flake!";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";

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
					inputs.home-manager.nixosModules.default
				];
			};
		};
		homeConfigurations.ebber = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;

			modules = [
				./home.nix
			];
		};
		home-manager.backupFileExtension = "bak";
	};
}
