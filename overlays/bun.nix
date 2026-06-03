final: prev:
{
    bun = prev.bun.overrideAttrs(oldAttrs: rec {
        version = "1.3.13";
        src = prev.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
            hash = "sha256-nYokKSpwaAkCBdqsCloiP19pc29Sh+N7+I07QDHtx1A=";
        };
    });
}
