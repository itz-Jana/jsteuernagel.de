{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    papermod = { url = "github:itz-Jana/zola-theme-papermod"; flake = false; };
  };
  outputs = { self, nixpkgs, flake-utils, papermod }:
    flake-utils.lib.eachDefaultSystem
    (
      system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          themeName = (nixpkgs.lib.removeSuffix "\n" (builtins.fromTOML (builtins.readFile "${papermod}/theme.toml")).name);

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
                listen [::]:${nginxPort} ipv6only=on;
                index index.html;

                gzip on;
                gzip_disable "msie6";

                gzip_vary on;
                gzip_proxied any;
                gzip_comp_level 6;
                gzip_buffers 16 8k;
                gzip_http_version 1.1;
                gzip_min_length 256;
                gzip_types
                  application/atom+xml
                  application/geo+json
                  application/javascript
                  application/x-javascript
                  application/json
                  application/ld+json
                  application/manifest+json
                  application/rdf+xml
                  application/rss+xml
                  application/xhtml+xml
                  application/xml
                  font/eot
                  font/otf
                  font/ttf
                  image/svg+xml
                  text/css
                  text/javascript
                  text/plain
                  text/xml;

                location ~ /\.(?!well-known).* {
                  deny all;
                  access_log off;
                  log_not_found off;
                  return 404;
                }
                location /.well-known/matrix {
                  resolver [2606:4700:4700::1111]:53 valid=30s;
                  proxy_pass https://matrix.jsteuernagel.de/.well-known/matrix;
                  proxy_set_header X-Forwarded-For $remote_addr;
                  proxy_ssl_server_name on;
                }
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
            DOCKER_REPOSITORY="docker://ghcr.io/itz-jana/jsteuernagel.de"
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
