{
  description = "Texture analysis thesis";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils = { url = "github:numtide/flake-utils"; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          devShell = pkgs.mkShell {
            packages = [
              # paper dev
              (pkgs.texlive.combine {
                inherit (pkgs.texlive)
                  scheme-small
                  latexmk
                  latexindent
                  # extra tex packages go here
                  biblatex
                  ;
              })
            ];
          };
        });
}
