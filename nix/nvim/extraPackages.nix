{ config
, pkgs
}:
let
  runtimeDeps = with pkgs; [
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
  ];

  treefmt-programs = builtins.attrValues config.treefmt.build.programs;
in
runtimeDeps ++ treefmt-programs
