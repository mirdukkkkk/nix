{ inputs, ... }:
{
    nixpkgs = {
        config.allowUnfree = true;
        overlays = [
            inputs.nix-cachyos-kernel.overlays.default
            (final: prev: {
                unstable = import inputs.nixpkgs-unstable {
                    system = prev.system;
                    config = prev.config;
                };
            })
            (final: prev: {
                beefetch = inputs.beefetch.packages.${prev.system}.default;
                iloader = inputs.iloader.packages.${prev.stdenv.hostPlatform.system}.default;
            })
        ];
    };
}
