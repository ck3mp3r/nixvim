{
  description = "A nixvim configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    devshell,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        overlays = [devshell.overlays.default];
        pkgs = import nixpkgs {
          inherit system overlays;
          config = {allowUnfree = true;};
        };
        config = pkgs.callPackage ./nix/config.nix {};
        plugins = pkgs.callPackage ./nix/plugins.nix {};
        nvim' = avanteProvider: appName:
          pkgs.callPackage ./nix/wrapper.nix {
            inherit appName;
            configPath = "${config}";
            runtimePaths =
              [
                pkgs.vimPlugins.lazy-nvim
              ]
              ++ plugins.runtimePaths;
            extraVars = plugins.extraVars // {"avante_provider" = avanteProvider;};
          };

        # Base package set without nvim
        basePackages = with pkgs; {
          inherit
            lua
            luarocks
            nodejs
            python3
            shfmt
            stylua
            vtsls
            vscode-js-debug
            ;
          pip = python3Packages.pip;
        };

        # Function to create a complete package set with specified avante provider
        makePackageSet = avanteProvider: appName:
          basePackages
          // {
            nvim = nvim' avanteProvider appName;
          };

        # Create both variants
        copilotPackages = makePackageSet "copilot" "nvim";
        claudePackages = makePackageSet "claude" "nvim";

        # Helper function to create a package environment
        mkXvimEnv = name: packages:
          pkgs.buildEnv {
            inherit name;
            paths = builtins.attrValues packages;
            buildInputs = [pkgs.makeWrapper];
            postBuild = ''
              if [ -f $out/bin/nvim ]; then
                mv $out/bin/nvim $out/bin/${name}
              fi
            '';
          };
      in {
        formatter = pkgs.alejandra;

        # Expose all individual packages from copilotPackages as the base
        packages =
          copilotPackages
          // {
            # And add our bundled environments
            default = mkXvimEnv "xvim" copilotPackages;
            claude = mkXvimEnv "xvim-claude" claudePackages;
          };

        # Apps for direct execution
        apps.default = {
          type = "app";
          program = "${copilotPackages.nvim}/bin/nvim";
        };

        apps.claude = {
          type = "app";
          program = "${claudePackages.nvim}/bin/nvim";
        };

        devShells.default = pkgs.devshell.mkShell {
          imports = [(pkgs.devshell.importTOML ./devshell.toml)];
        };
      }
    );
}
