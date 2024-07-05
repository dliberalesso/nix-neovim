{ config
, lib
, pkgs
}:
let
  neovim-unwrapped = pkgs.neovim;

  patchedNeovim = neovim-unwrapped.overrideAttrs (oa: {
    patches = oa.patches ++ [ ./0001-NIX_ABS_PATH.patch ];
  });

  extraPackages = import ./extraPackages.nix { inherit config pkgs; };

  extraLuaPackages = import ./extraLuaPackages.nix;

  plugins = import ./plugins.nix { inherit pkgs; };

  nvim = import ./mkNvim.nix {
    inherit lib pkgs;
    inherit extraPackages extraLuaPackages plugins;
    inherit neovim-unwrapped;
  };

  nvim-dev = import ./mkNvim.nix {
    inherit lib pkgs;
    inherit extraPackages extraLuaPackages plugins;
    neovim-unwrapped = patchedNeovim;
  };
in
{
  inherit nvim nvim-dev;

  default = nvim;
}
