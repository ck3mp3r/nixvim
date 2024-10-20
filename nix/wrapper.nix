{
  pkgs,
  stdenvNoCC,
  lib,
  neovim,
  configLocation,
  appName,
  extraVars ? {},
  runtimePaths ? [],
}: let
  # Generate the variable commands string in Nix
  extraVarsList = lib.attrsets.mapAttrsToList (name: value: "--cmd \"let g:${name}='${value}'\"") extraVars;
  varCommands = lib.concatStringsSep " " extraVarsList;

  # Generate the runtime path commands string in Nix
  runtimePathCommands = lib.concatStringsSep " " (map (path: "--cmd \"set runtimepath^=${path}\"") runtimePaths);

  extraPackages = with pkgs; [
    alejandra
    lldb
    lua-language-server
    # luarocks
    nixd
    nodePackages.bash-language-server
    nodePackages.vscode-json-languageserver
    shellcheck
    shfmt
    vscode-extensions.vadimcn.vscode-lldb.adapter
    yaml-language-server
  ];

  extraPath = pkgs.lib.makeBinPath extraPackages;
in
  stdenvNoCC.mkDerivation {
    name = appName;
    src = ./.;

    buildInputs = [pkgs.neovim] ++ extraPackages;

    installPhase = ''
          mkdir -p $out/bin

          cat > $out/bin/${appName} <<EOF
      #!/usr/bin/env bash
      export PATH=${extraPath}:\$PATH
      exec ${neovim}/bin/nvim \
        --cmd "set runtimepath^=${configLocation}" \
        ${runtimePathCommands} \
        ${varCommands} \
        -u ${configLocation}/init.lua "\$@"
      EOF

          chmod +x $out/bin/${appName}
    '';

    shellHook = ''
      export PATH=${extraPath}:$PATH
    '';
  }
