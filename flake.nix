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
        git-hooks.follows = "git-hooks";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plugins
    astrocore = {
      url = "github:AstroNvim/astrocore";
      flake = false;
    };

    resession-nvim = {
      url = "github:stevearc/resession.nvim";
      flake = false;
    };

    astrolsp = {
      url = "github:AstroNvim/astrolsp";
      flake = false;
    };

    astroui = {
      url = "github:AstroNvim/astroui";
      flake = false;
    };

    catppuccin-nvim = {
      url = "github:catppuccin/nvim";
      flake = false;
    };

    luvit-meta = {
      url = "github:Bilal2453/luvit-meta";
      flake = false;
    };

    mini-ai = {
      url = "github:echasnovski/mini.ai";
      flake = false;
    };

    mini-bufremove = {
      url = "github:echasnovski/mini.bufremove";
      flake = false;
    };

    mini-surround = {
      url = "github:echasnovski/mini.surround";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = with inputs; [
        flake-parts.flakeModules.easyOverlay
        flake-root.flakeModule
        git-hooks.flakeModule
        treefmt-nix.flakeModule
      ];

      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { config, pkgs, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.neovim-nightly.overlays.default
          ];
        };

        overlayAttrs = {
          inherit (config.packages) nvim-dev nvim-with-aliases;
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.just
          ];

          packages = [
            config.packages.nvim-dev
          ];

          shellHook = ''
            ${config.pre-commit.installationScript}
            export NIX_ABS_CONFIG="$PWD"
          '';
        };

        packages = import ./nix/neovimPackages.nix {
          inherit inputs pkgs;
          treefmtPrograms = builtins.attrValues config.treefmt.build.programs;
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
