{
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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-root.url = "github:srid/flake-root";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-root.flakeModule
        inputs.git-hooks.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { config, system, ... }:
        let
          neovimOverlay = inputs.neovim-nightly.overlays.default;

          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ neovimOverlay ];
          };
        in
        {

          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.just
            ];

            packages = [
              # Formatters
              pkgs.prettierd

              # Language Servers
              pkgs.lua-language-server
              pkgs.marksman
              pkgs.nixd
              pkgs.vscode-langservers-extracted
              pkgs.yaml-language-server

              # Linters/Static analyzers
              pkgs.selene
            ] ++ builtins.attrValues config.treefmt.build.programs;

            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };

          packages.default = pkgs.neovim;

          pre-commit.check.enable = true;
          pre-commit.settings.hooks = {
            treefmt = {
              enable = true;
              package = config.treefmt.build.wrapper;
            };
          };

          treefmt = {
            inherit (config.flake-root) projectRootFile;
            programs = {
              deadnix.enable = true;
              prettier.enable = true;
              nixpkgs-fmt.enable = true;
              shfmt.enable = true;
              stylua.enable = true;
              statix.enable = true;
              taplo.enable = true;
            };
          };
        };
    };
}
