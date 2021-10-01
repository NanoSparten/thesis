{
  description = "Texture analysis thesis";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils = { url = "github:numtide/flake-utils"; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    devshell-flake = { url = "github:numtide/devshell"; };
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat, devshell-flake }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              devshell-flake.overlay
            ];
          };
        in
        {
          devShell = with pkgs;  devshell.mkShell
            {
              packages = [
                julia_16-bin

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

              commands = [{
                name = "pluto";
                category = "Julia";
                command = ''
                  eval $(echo "julia -e 'import Pkg; Pkg.activate(\".\"); using Pluto; Pluto.run()'")
                '';
                help = "launch pluto server";
              }];

              env = [
                {
                  name = "JULIA_PROJECT";
                  value = ".";
                }
              ];
            };
        });
}
