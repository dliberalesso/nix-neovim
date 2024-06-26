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

    gen-luarc = {
      url = "github:mrcjkb/nix-gen-luarc-json";
      inputs.flake-parts.follows = "flake-parts";
    };

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
        flake-root.flakeModule
        git-hooks.flakeModule
        treefmt-nix.flakeModule
      ];

      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { self', config, system, ... }:
        let
          treefmtPrograms = builtins.attrValues config.treefmt.build.programs;

          neovim-overlay = import ./nix/neovim-overlay.nix { inherit inputs treefmtPrograms; };

          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.gen-luarc.overlays.default
              inputs.neovim-nightly.overlays.default
              neovim-overlay
            ];
          };
        in
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.just
            ];

            packages = [
              self'.packages.nvim-dev
            ];

            shellHook = ''
              ${config.pre-commit.installationScript}
              # symlink the .luarc.json generated in the overlay
              ln -fs ${pkgs.nvim-luarc-json} .luarc.json
              export NIX_ABS_CONFIG="$PWD"
            '';
          };

          packages = rec {
            default = nvim;
            nvim = pkgs.nvim-pkg;
            nvim-dev = pkgs.nvim-pkg-dev;
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
