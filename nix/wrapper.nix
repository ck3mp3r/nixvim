{
  stdenv,
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
in
  stdenv.mkDerivation {
    name = appName;
    src = ./.;
    installPhase = ''
          mkdir -p $out/bin

          cat > $out/bin/${appName} <<EOF
      #!/usr/bin/env bash
      exec ${neovim}/bin/nvim \
        --cmd "set runtimepath^=${configLocation}" \
        ${runtimePathCommands} \
        ${varCommands} \
        -u ${configLocation}/init.lua "\$@"
      EOF

          chmod +x $out/bin/${appName}
    '';
  }
