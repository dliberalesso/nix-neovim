{
  description = "My Neovim Flake";

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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-root.url = "github:srid/flake-root";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    mnw.url = "github:Gerg-L/mnw";

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        hercules-ci-effects.follows = "hercules-ci-effects";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-root.flakeModule
        inputs.git-hooks.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = [ "x86_64-linux" ];

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.just
            ];

            packages = [
              config.packages.default.devMode
            ];

            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };

          packages.default = inputs.mnw.lib.wrap pkgs {
            inherit (inputs.neovim-nightly.packages.${system}) neovim;

            initLua = ''
              require('nixneovim')
            '';

            devExcludedPlugins = [ ./nixneovim ];
            devPluginPaths = [ "./nixneovim" ];
          };

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
              nixfmt.enable = true;
              shfmt.enable = true;
              stylua.enable = true;
              statix.enable = true;
              taplo.enable = true;
            };
          };
        };
    };
}
