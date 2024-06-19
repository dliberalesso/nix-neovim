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

    lz-n = {
      url = "github:nvim-neorocks/lz.n";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        gen-luarc.follows = "gen-luarc";
        neorocks.follows = "neorocks";
        pre-commit-hooks.follows = "git-hooks";
      };
    };

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

      perSystem = { config, lib, system, ... }:
        let
          genLuarcOverlay = inputs.gen-luarc.overlays.default;
          lznOverlay = inputs.lz-n.overlays.default;
          nightlyNeovimOverlay = inputs.neovim-nightly.overlays.default;

          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ nightlyNeovimOverlay lznOverlay genLuarcOverlay ];
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

            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };

          packages = rec {
            neovim =
              let
                runtimeDeps = [
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
              in
              pkgs.wrapNeovimUnstable patchedNeovim (
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

                    plugins = with pkgs.vimPlugins; [
                      catppuccin-nvim
                      lz-n
                      {
                        plugin = pkgs.vimPlugins.telescope-nvim;
                        optional = true;
                      }
                      {
                        plugin = pkgs.vimPlugins.vim-startuptime;
                        optional = true;
                      }
                    ];
                  } // {
                  wrapperArgs = [
                    "--set"
                    "NIX_ABS_CONFIG"
                    "${./.}"
                    "--prefix"
                    "PATH"
                    ":"
                    "${lib.makeBinPath runtimeDeps}"
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
