{
  description = "dev shell for threestudio";

  inputs = { 
    nixpkgs.url = "nixpkgs/nixos-unstable"; 
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in {
        devShells.default = pkgs.mkShell {
          name = "Threestudio";
          buildInputs = with pkgs; [
            gcc
            glibc
            libcxx
            stdenv.cc.cc.lib
            python312
            python312Packages.pip
            cudatoolkit
          ];


          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:$LD_LIBRARY_PATH
          '';
        };
      }
    );
}
