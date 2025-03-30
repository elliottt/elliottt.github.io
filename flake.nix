{
  description = "elliottt.github.io build environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        texlive = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-minimal
          latex-bin latexmk biber
          moderncv biblatex
          fontawesome5 pgf multirow arydshln txfonts colortbl geometry
          infwarerr luatexbase academicons epstopdf epstopdf-pkg;
        };
      in {
        devShells = {
          default = pkgs.mkShell {
            name = "hugo";
            nativeBuildInputs = [
              pkgs.hugo
              pkgs.git
              pkgs.gnumake
              pkgs.rclone

              texlive
            ];
          };
        };
      });
}
