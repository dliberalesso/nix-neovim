{ config
, lib
, pkgs
}:
import ./mkNvim.nix {
  inherit lib pkgs;

  extraPackages = import ./extraPackages.nix { inherit config pkgs; };

  extraLuaPackages = p: [
    p.jsregexp
  ];

  plugins = import ./plugins.nix { inherit pkgs; };

  neovim-unwrapped = pkgs.neovim-nightly;
}
