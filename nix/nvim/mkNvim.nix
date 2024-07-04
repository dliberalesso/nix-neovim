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
, withRuby ? false
}:
let
  patchedNeovim = neovim-unwrapped.overrideAttrs (_oa: {
    patches = [ ./0001-NIX_ABS_PATH.patch ];
  });

  # Add arguments to the Neovim wrapper script
  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    ''--prefix PATH : "${lib.makeBinPath (extraPackages ++ [ pkgs.sqlite ])}"''
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

  # Disable RTP plugins
  # removeRtpPaths = map (target: "rm -f $out/share/nvim/${target}") [
  #   "runtime/plugin/matchit.vim"
  # ];

  neovim-wrapped = pkgs.wrapNeovimUnstable patchedNeovim (
    pkgs.neovimUtils.makeNeovimConfig {
      inherit defaultEditor;
      inherit viAlias vimAlias vimdiffAlias;
      inherit withNodeJs withPerl withPython3 withRuby;
      inherit plugins;

      wrapperArgs = lib.escapeShellArgs ""
        + extraMakeWrapperArgs
        + " "
        + extraMakeWrapperLuaCArgs
        + " "
        + extraMakeWrapperLuaArgs;

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
