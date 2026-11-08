{ inputs, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ../../../packages)
      inputs.claude-code.overlays.default
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = prev.stdenv.hostPlatform.system;
          config = prev.config;
        };
      })
      (final: prev: {
        mongodb-compass = prev.mongodb-compass.overrideAttrs (old: {
          buildCommand =
            builtins.replaceStrings
              [ "wrapGAppsHook $out/bin/mongodb-compass" ]
              [ "wrapGApp $out/bin/mongodb-compass" ]
              old.buildCommand;
        });
        # VS Code >= 1.122 ships ripgrep under @vscode/ripgrep-universal, but
        # release-26.05 still patches the old path. Drop once
        # https://github.com/NixOS/nixpkgs/issues/584492 is fixed on 26.05.
        vscode = prev.vscode.overrideAttrs (old: {
          postPatch =
            builtins.replaceStrings
              [ "resources/app/node_modules/@vscode/ripgrep/bin/rg" ]
              [ "resources/app/node_modules/@vscode/ripgrep-universal/bin/linux-x64/rg" ]
              old.postPatch;
        });
      })
    ];
  };
}
