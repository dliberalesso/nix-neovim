{ config
, lib
, pkgs
}:
let
  patchedNeovim = pkgs.neovim-nightly.overrideAttrs (_old: {
    patches = [ ./0001-NIX_ABS_PATH.patch ];
  });

  extraPackages = with pkgs; [
    # Formatters
    prettierd

    # Language Servers
    lua-language-server
    marksman
    nixd
    vscode-langservers-extracted
    yaml-language-server

    # Linters/Static analyzers
    selene

    # Others
    sqlite
  ];

  treefmt-programs = builtins.attrValues config.treefmt.build.programs;

  extraLuaPackages = p: [
    p.jsregexp
  ];

  # Add arguments to the Neovim wrapper script
  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    ''--prefix PATH : "${lib.makeBinPath (extraPackages ++ treefmt-programs)}"''
    # Set the LIBSQLITE_CLIB_PATH if sqlite is enabled
    ++ ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"''
    # Set the LIBSQLITE environment variable if sqlite is enabled
    ++ ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"''
  );

  luaPackages = patchedNeovim.lua.pkgs;
  resolvedExtraLuaPackages = extraLuaPackages luaPackages;

  # Native Lua libraries
  extraMakeWrapperLuaCArgs =
    ''--suffix LUA_CPATH ";" "${lib.concatMapStringsSep ";" luaPackages.getLuaCPath resolvedExtraLuaPackages}"'';

  # Lua libraries
  extraMakeWrapperLuaArgs =
    ''--suffix LUA_PATH ";" "${lib.concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages}"'';

  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.overrideAttrs (_:
    let
      treesitter-parser-paths =
        pkgs.symlinkJoin {
          name = "treesitter-parsers";
          paths = nvim-treesitter.dependencies;
        };
    in
    {
      postPatch = ''
        mkdir -p parser
        cp -r ${treesitter-parser-paths.outPath}/parser/*.so parser
      '';
    });
in
pkgs.wrapNeovimUnstable patchedNeovim (
  pkgs.neovimUtils.makeNeovimConfig {
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = false;
    withPerl = false;
    withPython3 = false;
    withRuby = false;

    wrapperArgs = [
      extraMakeWrapperArgs
      extraMakeWrapperLuaCArgs
      extraMakeWrapperLuaArgs
    ];

    wrapRc = false;

    plugins = [
      pkgs.vimPlugins.lz-n
      {
        plugin = pkgs.vimPlugins.vim-startuptime;
        optional = true;
      }
      {
        plugin = nvim-treesitter;
        optional = true;
      }
    ];
  }
)
