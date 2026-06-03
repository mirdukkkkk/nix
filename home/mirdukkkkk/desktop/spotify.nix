{ pkgs, ... }:
let
    spotify-adblock = pkgs.rustPlatform.buildRustPackage rec {
        pname = "spotify-adblock";
        version = "1.0.3";
        src = pkgs.fetchFromGitHub {
            owner = "abba23";
            repo = "spotify-adblock";
            rev = "813d3451c53126bf1941baaf8dd37f1152c3f412";
            sha256 = "sha256-nwiX2wCZBKRTNPhmrurWQWISQdxgomdNwcIKG2kSQsE=";
        };

        cargoHash = "sha256-oGpe+kBf6kBboyx/YfbQBt1vvjtXd1n2pOH6FNcbF8M=";

        installPhase = ''
            mkdir -p $out/lib
            mkdir -p $out/share/spotify-adblock

            cp target/x86_64-unknown-linux-gnu/release/libspotifyadblock.so \
                $out/lib/libspotifyadblock.so
            cp config.toml $out/share/spotify-adblock/config.toml
        '';
    };

    spotify = pkgs.symlinkJoin {
        name = "spotify";

        paths = [ pkgs.spotify ];
        buildInputs = [ pkgs.makeWrapper ];

        postBuild = ''
            wrapProgram $out/bin/spotify \
                --set LD_PRELOAD \
                ${spotify-adblock}/lib/libspotifyadblock.so
        '';
    };
in
{
    home.packages = [ spotify ];

    xdg.configFile."spotify-adblock/config.toml".source = "${spotify-adblock}/share/spotify-adblock/config.toml";
}
