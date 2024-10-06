{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = [
              pkgs.hugo
              pkgs.go
              pkgs.git
              pkgs.coreutils
            ];
          };
        };
        apps = {
          publish = flake-utils.lib.mkApp {
            drv = pkgs.writeShellApplication {
              name = "script";
              runtimeInputs = [
                pkgs.git
                pkgs.go
                pkgs.hugo
                pkgs.coreutils
              ];
              text = ''
                set -ex
                hugo >stdout 2>stderr
              '';
            };
          };
        };
      }
    );
}
