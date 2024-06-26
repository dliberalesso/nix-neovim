# Function for creating a Neovim derivation
{ pkgs
, lib
, # Set by the overlay to ensure we use a compatible version of `wrapNeovimUnstable`
  pkgs-wrapNeovim ? pkgs
,
}:
with lib;
{
  # NVIM_APPNAME - Defaults to 'nvim' if not set.
  # If set to something else, this will also rename the binary.
  appName ? null
, dev ? false
, # The Neovim package to wrap
  neovim-unwrapped ? pkgs-wrapNeovim.neovim-unwrapped
, plugins ? [ ]
, # List of plugins
  extraPackages ? [ ]
, # Extra runtime dependencies (e.g. ripgrep, ...)
  # The below arguments can typically be left as their defaults
  # Additional lua packages (not plugins), e.g. from luarocks.org.
  # e.g. p: [p.jsregexp]
  extraLuaPackages ? _p: [ ]
, extraPython3Packages ? _p: [ ]
, # Additional python 3 packages
  withPython3 ? false
, # Build Neovim with Python 3 support?
  withRuby ? false
, # Build Neovim with Ruby support?
  withNodeJs ? false
, # Build Neovim with NodeJS support?
  withSqlite ? true
, # Add sqlite? This is a dependency for some plugins
  # You probably don't want to create vi or vim aliases
  # if the appName is something different than "nvim"
  viAlias ? appName == "nvim" && !dev
, # Add a "vi" binary to the build output as an alias?
  vimAlias ? appName == "nvim" && !dev
, # Add a "vim" binary to the build output as an alias?
  defaultEditor ? appName == "nvim" && !dev
,
}:
let
  patchedNeovim = neovim-unwrapped.overrideAttrs (_old: {
    patches = [ ./0001-NIX_ABS_PATH.patch ];
  });

  lazyPlugins = plugins;

  processPlugin =
    plugin:
    let
      mkEntryFromDrv =
        p:
        if lib.isDerivation p then
          {
            name = "${lib.getName p}";
            path = p;
          }
        else
          {
            name = "${lib.getName p.pkg}";
            path = p.pkg;
          };
    in
    [ (mkEntryFromDrv plugin) ];

  processedPlugins = builtins.concatLists (builtins.map processPlugin lazyPlugins);
  lazyPath = pkgs.linkFarm "lazy-plugins" processedPlugins;

  externalPackages = extraPackages ++ (optionals withSqlite [ pkgs.sqlite ]);

  # This nixpkgs util function creates an attrset
  # that pkgs.wrapNeovimUnstable uses to configure the Neovim build.
  neovimConfig = pkgs-wrapNeovim.neovimUtils.makeNeovimConfig {
    inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias defaultEditor;
  };

  # Add arguments to the Neovim wrapper script
  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    # Set the NVIM_APPNAME environment variable
    (optional (appName != "nvim" && appName != null && appName != "")
      ''--set NVIM_APPNAME "${appName}"'')
    # Add external packages to the PATH
    ++ (optional (externalPackages != [ ])
      ''--prefix PATH : "${makeBinPath externalPackages}"'')
    # Set the LIBSQLITE_CLIB_PATH if sqlite is enabled
    ++ (optional withSqlite
      ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
    # Set the LIBSQLITE environment variable if sqlite is enabled
    ++ (optional withSqlite
      ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
  );

  luaPackages = patchedNeovim.lua.pkgs;
  resolvedExtraLuaPackages = extraLuaPackages luaPackages;

  # Native Lua libraries
  extraMakeWrapperLuaCArgs =
    optionalString (resolvedExtraLuaPackages != [ ])
      ''--suffix LUA_CPATH ";" "${concatMapStringsSep ";" luaPackages.getLuaCPath resolvedExtraLuaPackages}"'';

  # Lua libraries
  extraMakeWrapperLuaArgs =
    optionalString (resolvedExtraLuaPackages != [ ])
      ''--suffix LUA_PATH ";" "${concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages}"'';

  # Config files
  extraMakeWrapperConfigFiles =
    optionalString (! dev)
      ''--set NIX_ABS_CONFIG "${"${../.}"}"'';

  # Lazy root dir
  extraMakeWrapperLazyRootDir = ''--set LAZY_ROOT_DIR "${lazyPath}"'';

  # wrapNeovimUnstable is the nixpkgs utility function for building a Neovim derivation.
  neovim-wrapped = pkgs-wrapNeovim.wrapNeovimUnstable patchedNeovim (neovimConfig
    // {
    wrapperArgs =
      escapeShellArgs neovimConfig.wrapperArgs
        + " "
        + extraMakeWrapperArgs
        + " "
        + extraMakeWrapperLuaCArgs
        + " "
        + extraMakeWrapperLuaArgs
        + " "
        + extraMakeWrapperConfigFiles
        + " "
        + extraMakeWrapperLazyRootDir;
    wrapRc = false;
  });

  isCustomAppName = appName != null && appName != "nvim";
in
neovim-wrapped.overrideAttrs (oa: {
  buildPhase =
    oa.buildPhase
    # If a custom NVIM_APPNAME has been set, rename the `nvim` binary
    + lib.optionalString isCustomAppName ''
      mv $out/bin/nvim $out/bin/${lib.escapeShellArg appName}
    '';
})
