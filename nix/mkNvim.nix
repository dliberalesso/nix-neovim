{ lib
, pkgs
, defaultEditor ? true
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
    # Add external packages to the PATH
    (lib.optional (externalPackages != [ ])
      ''--prefix PATH : "${lib.makeBinPath externalPackages}"'')
    # Set the LIBSQLITE_CLIB_PATH if sqlite is enabled
    ++ (lib.optional withSqlite
      ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
    # Set the LIBSQLITE environment variable if sqlite is enabled
    ++ (lib.optional withSqlite
      ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
  );

  # FIXME:
  # Disable RTP plugins
  # removeRtpPaths = map (target: "rm -f $out/share/nvim/${target}") [
  #   "runtime/plugin/matchit.vim"
  # ];

  neovim-wrapped = pkgs.wrapNeovimUnstable neovim-unwrapped (
    neovimConfig // {
      wrapperArgs =
        lib.escapeShellArgs neovimConfig.wrapperArgs
        + " "
        + extraMakeWrapperArgs;
      wrapRc = false;
    }
  );
in
# neovim-wrapped.overrideAttrs (oa: {
  #   installPhase = ''
  #     ${oa.postInstall or ""}
  #     ${lib.concatStringsSep "\n" removeRtpPaths}
  #   '';
  # })
neovim-wrapped
