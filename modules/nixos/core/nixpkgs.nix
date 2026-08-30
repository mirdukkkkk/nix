{ inputs, ... }:
{
    nixpkgs = {
        config = {
            allowUnfree = true;
            permittedInsecurePackages = [
                "pnpm-10.29.2"
            ];
        };
        overlays = [
            inputs.claude-code.overlays.default
            (final: prev: {
                unstable = import inputs.nixpkgs-unstable {
                    system = prev.system;
                    config = prev.config;
                };
            })
            (final: prev: {
                mongodb-compass = prev.mongodb-compass.overrideAttrs (old: {
                    buildCommand = builtins.replaceStrings
                        [ "wrapGAppsHook $out/bin/mongodb-compass" ]
                        [ "wrapGApp $out/bin/mongodb-compass" ]
                    old.buildCommand;
                });
            })
            (final: prev: {
                molten = inputs.molten.packages.${prev.stdenv.hostPlatform.system}.default;
                iloader = inputs.iloader.packages.${prev.stdenv.hostPlatform.system}.default;
                beefetch = inputs.beefetch.packages.${prev.stdenv.hostPlatform.system}.default;
            })
            (final: prev: {
                clawd-on-desk = final.unstable.callPackage (inputs.self + "/pkgs/clawd") {
                    src = inputs.clawd-on-desk;
                };
            })
        ];
    };
}
