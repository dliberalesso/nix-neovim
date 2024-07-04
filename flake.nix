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

    # lz-n = {
    #   url = "github:nvim-neorocks/lz.n";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-parts.follows = "flake-parts";
    #     gen-luarc.follows = "gen-luarc";
    #     neorocks.follows = "neorocks";
    #     pre-commit-hooks.follows = "git-hooks";
    #   };
    # };

    neorocks = {
      url = "github:nvim-neorocks/neorocks";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        neovim-nightly.follows = "neovim-nightly";
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
    luvit-meta = {
      url = "github:Bilal2453/luvit-meta";
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

      systems = [ "x86_64-linux" ];

      perSystem = { config, lib, pkgs, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.neorocks.overlays.default
            inputs.gen-luarc.overlays.default
            # inputs.lz-n.overlays.default
          ];
        };

        overlayAttrs = {
          inherit (config.packages) nvim;
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.just
          ];

          packages = [
            config.packages.nvim
          ];

          shellHook = ''
            ${config.pre-commit.installationScript}
            export NIX_ABS_CONFIG="$PWD"
          '';
        };

        packages = rec {
          default = nvim;
          nvim = import ./nix/mkNvim.nix {
            inherit lib pkgs;

            extraPackages = import ./nix/extraPackages.nix { inherit config pkgs; };

            extraLuaPackages = import ./nix/extraLuaPackages.nix;

            plugins = import ./nix/plugins.nix { inherit pkgs; };

            neovim-unwrapped = pkgs.neovim-nightly;
          };
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
