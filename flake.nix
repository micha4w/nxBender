{
  description = "Open source client for netExtender SSL VPNs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    mach-nix.url = "github:davhau/mach-nix";
  };

  outputs = { self, nixpkgs, mach-nix, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        mach = mach-nix.lib.${system};
        nxBender = mach.buildPythonPackage {
          name = "nxBender";
          src = ./.;
          requirements = builtins.readFile ./requirements.txt;
          propagatedBuildInputs = [ pkgs.ppp ];
        };
      in
      {
        packages = {
          nxBender = nxBender;
          default = nxBender;
        };
        shells.default = pkgs.mkShellNoCC {
          packages = [
            nxBender
            pkgs.ppp
          ];
        };
      }
    );
}
