{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    papermod = { url = "github:cydave/zola-theme-papermod"; flake = false; };
  };
  outputs = { self, nixpkgs, flake-utils, papermod }:
    flake-utils.lib.eachDefaultSystem
    (
      system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          themeName = ((builtins.fromTOML (builtins.readFile "${papermod}/theme.toml")).name);
        in
        {
          packages.website = pkgs.stdenv.mkDerivation rec {
            name = "jsteuernagel-de-HEAD";
            src = ./.;
            nativeBuildInputs = [ pkgs.zola ];
            configurePhase = ''
              mkdir -p "themes/${themeName}"
              cp -r ${papermod}/* "themes/${themeName}"
            '';
            buildPhase = "zola build";
            installPhase = "cp -r public $out";
          };
          defaultPackage = self.packages.${system}.website;
          devShells.default = pkgs.mkShell {
            buildInputs = [ pkgs.zola ];
            shellHook = ''
              mkdir -p themes
              ln -sn "${papermod}" "themes/${themeName}"
            '';
          };
        }
    );
}
