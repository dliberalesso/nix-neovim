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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    flake-parts.url = "github:hercules-ci/flake-parts";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
    pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-compat.follows = "flake-compat";
    nixvim.inputs.flake-parts.follows = "flake-parts";
    nixvim.inputs.pre-commit-hooks.follows = "pre-commit-hooks";
  };

  outputs =
    { nixpkgs
    , flake-parts
    , nixvim
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.pre-commit-hooks.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        { config
        , pkgs
        , system
        , ...
        }:
        let
          nixvim' = nixvim.legacyPackages.${system};
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = import ./config;
          };
        in
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixpkgs-fmt.enable = true;
            };
          };

          pre-commit.check.enable = true;
          pre-commit.settings.hooks = {
            treefmt.enable = true;
            treefmt.package = config.treefmt.build.wrapper;
          };

          # Run `nix flake check .` to verify that your config is not broken
          checks.default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "My Neovim config";
          };

          # Lets you run `nix run .` to start nixvim
          packages.default = nvim;

          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              nvim
            ];
          };
        };
    };
}
