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
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.gen-luarc.overlays.default
              inputs.neovim-nightly.overlays.default
            ];
          };

          patchedNeovim = pkgs.neovim.overrideAttrs (_old: {
            patches = [ ./0001-NIX_ABS_PATH.patch ];
          });
        in
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.just
            ];

            packages = [
              self'.packages.neovim

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

          packages = rec {
            neovim = pkgs.wrapNeovimUnstable patchedNeovim (
              pkgs.neovimUtils.makeNeovimConfig
                {
                  defaultEditor = true;

                  viAlias = true;
                  vimAlias = true;
                  vimdiffAlias = true;

                  withNodeJs = false;
                  withPerl = false;
                  withPython3 = false;
                  withRuby = false;

                  wrapRc = false;
                } // {
                wrapperArgs = [
                  "--set"
                  "NIX_ABS_CONFIG"
                  "${./.}"
                  "--set"
                  "LAZY_ROOT_DIR"
                  # TODO: look into how nixvim set this using `linkFarm`
                  "/home/dli/.local/share/nvim/lazy/"
                ];
              }
            );

            default = neovim;
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
