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

          website = pkgs.stdenv.mkDerivation rec {
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

          nginxPort = "80";
          nginxConf = pkgs.writeText "nginx.conf" ''
            user nobody nobody;
            daemon off;
            error_log /dev/stdout info;
            pid /dev/null;
            events {}
            http {
              include ${pkgs.nginx}/conf/mime.types;
              access_log /dev/stdout;
              server {
                listen [::]:${nginxPort} ipv6only=on;;
                index index.html;
                location / {
                  root ${website};
                }
              }
            }
          '';

          dockerImage = pkgs.dockerTools.buildLayeredImage {
            name = "jsteuernagel-de";
            contents = [ pkgs.dockerTools.fakeNss ];
            extraCommands = ''
              mkdir -p tmp/nginx_client_body
              mkdir -p var/log/nginx
            '';
            config = {
              Cmd = [ "${pkgs.nginx}/bin/nginx" "-c" nginxConf ];
              ExposedPorts = {
                "${nginxPort}/tcp" = { };
              };
            };
          };

          upload-script = pkgs.writeShellScriptBin "upload-image" ''
            set -eu
            OCI_ARCHIVE=$(nix build --no-link --print-out-paths --no-warn-dirty)
            DOCKER_REPOSITORY="docker://ghcr.io/j0n4t4n/jsteuernagel.de"
            ${pkgs.skopeo}/bin/skopeo --insecure-policy copy --dest-creds="$GITHUB_USER:$GITHUB_TOKEN" "docker-archive:$OCI_ARCHIVE" "$DOCKER_REPOSITORY"
          '';

        in
        {
          packages = {
            html = website;
            docker = dockerImage;
            upload-script = upload-script;
          };

          defaultPackage = dockerImage;

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
