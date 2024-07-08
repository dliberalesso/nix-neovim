{ config
, lib
, pkgs
}:
let
  mk-nvim-config = {
    inherit lib pkgs;

    extraPackages = import ./extraPackages.nix { inherit config pkgs; };

    extraLuaPackages = import ./extraLuaPackages.nix;

    plugins = import ./plugins.nix { inherit pkgs; };

    neovim-unwrapped = pkgs.neovim;
  };
in
rec {
  nvim = import ./mkNvim.nix mk-nvim-config;

  nvim-dev = import ./mkNvim.nix (mk-nvim-config // { dev = true; });

  default = nvim;
}
