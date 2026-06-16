{ pkgs, ... }:
{
    home.packages = with pkgs; [ 
        (pkgs.bun.overrideAttrs(oldAttrs: rec {
            version = "1.3.14";
            src = pkgs.fetchurl {
                url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
                hash = "sha256-oGOQiuCLeFLKEJObvcbO7T3avOj7lALc6D1l1zs25sc=";
            };
        }))
        nodejs_24
        yarn 
    ];
}
