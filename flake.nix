{
  description = "My Neovim config";

  nixConfig = {
    extra-substituters = [
      "https://cachix.cachix.org"
      "https://nix-community.cachix.org"
      "https://dliberalesso.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "dliberalesso.cachix.org-1:7qs1S5Qd766dYFU86nVux/wRMZ8UEUbhn3Qxp/TwiOc="
    ];
  };

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;

    flake-compat.url = github:edolstra/flake-compat;
    flake-compat.flake = false;

    flake-utils.url = github:numtide/flake-utils;

    neovim-upstream.url = github:neovim/neovim?dir=contrib;
    neovim-upstream.inputs.nixpkgs.follows = "nixpkgs";
    neovim-upstream.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { nixpkgs, flake-utils, neovim-upstream, ... } @ inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem mkApp;
    in

    eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            neovim-upstream.overlay
          ];
        };
      in

      rec {
        apps = rec {
          nvim = mkApp {
            drv = packages.neovim;
            exePath = "/bin/nvim";
          };

          default = nvim;
        };

        devShells.default = with pkgs; mkShell {
          buildInputs = [
            packages.neovim
            nixpkgs-fmt
            rnix-lsp
          ];
        };

        formatter = pkgs.nixpkgs-fmt;

        packages = rec {
          neovim = pkgs.neovim;
          default = neovim;
        };
      }
    );
}
