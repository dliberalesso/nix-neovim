{
  description = "My Neovim config";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = with pkgs; mkShell {
          buildInputs = [
            rnix-lsp
          ];
        };
      }
    );
}
