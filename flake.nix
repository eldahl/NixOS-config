{
	description = "My First Flake!";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.05";

		home-manager = {
			url = "github:nix-community/home-manager/release-24.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, ... }@inputs: 
		let 
			lib = nixpkgs.lib;
		in {
		nixosConfigurations = {
			desktop = lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {inherit inputs;};
				modules = [ 
					./configuration.nix 
					inputs.home-manager.nixosModules.default
				];
			};
		};
	};
}
