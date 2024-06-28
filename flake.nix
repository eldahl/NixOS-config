{
	description = "My First Flake!";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.05";
	};

	outputs = { self, nixpkgs, ... }: 
		let 
			lib = nixpkgs.lib;
		in {
		nixosConfigurations = {
			desktop = lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ ./configuration.nix ];
			};
		};
	};
}
