{ lib
, pkgs
, defaultEditor ? true
, dev ? false
, extraPackages ? [ ]
, extraLuaPackages ? _p: [ ]
, neovim-unwrapped ? pkgs.neovim-unwrapped
, plugins ? [ ]
, viAlias ? true
, vimAlias ? true
, vimdiffAlias ? true
, withNodeJs ? false
, withPerl ? false
, withPython3 ? false
, withSqlite ? true
, withRuby ? false
}:
let
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    inherit defaultEditor;
    inherit extraLuaPackages;
    inherit viAlias vimAlias vimdiffAlias;
    inherit withNodeJs withPerl withPython3 withRuby;

    plugins =
      let
        defaultPlugin = {
          plugin = null;
          config = null;
          optional = true;
        };
      in
      map (x: defaultPlugin // (if (x ? plugin) then x else { plugin = x; })) plugins;
  };

  externalPackages = extraPackages ++ (lib.optionals withSqlite [ pkgs.sqlite ]);

  # Add arguments to the Neovim wrapper script
  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    # Set $VIM
    [ ''--set VIM "${placeholder "out"}/share/nvim"'' ]
    # Add external packages to the PATH
    ++ (lib.optional (externalPackages != [ ])
      ''--prefix PATH : "${lib.makeBinPath externalPackages}"'')
    # Set the LIBSQLITE_CLIB_PATH if sqlite is enabled
    ++ (lib.optional withSqlite
      ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
    # Set the LIBSQLITE environment variable if sqlite is enabled
    ++ (lib.optional withSqlite
      ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
  );

  patchedNeovim = neovim-unwrapped.overrideAttrs (oa: {
    patches = oa.patches ++ (lib.optional dev ./0001-NIX_ABS_PATH.patch);
  });

  neovim-wrapped = pkgs.wrapNeovimUnstable patchedNeovim (
    neovimConfig // {
      wrapperArgs =
        lib.escapeShellArgs neovimConfig.wrapperArgs
        + " "
        + extraMakeWrapperArgs;
      wrapRc = false;
    }
  );

  # Disable RTP plugins
  removeRuntimePlugins = map (target: "rm -f $out/share/nvim/${target}") [
    "runtime/menu.vim"
    "runtime/mswin.vim"
    "runtime/plugin/gzip.vim"
    "runtime/plugin/matchit.vim"
    "runtime/plugin/matchparen.vim"
    "runtime/plugin/netrwPlugin.vim"
    "runtime/plugin/osc52.lua"
    "runtime/plugin/rplugin.vim"
    "runtime/plugin/rplugin.vim.orig"
    "runtime/plugin/spellfile.vim"
    "runtime/plugin/tarPlugin.vim"
    "runtime/plugin/tohtml.lua"
    "runtime/plugin/tutor.vim"
    "runtime/plugin/zipPlugin.vim"
  ];
in
neovim-wrapped.overrideAttrs (oa: {
  postInstall = ''
    ${oa.postInstall or ""}
    ${lib.concatStringsSep "\n" removeRuntimePlugins}
  '';
})
