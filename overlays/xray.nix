final: prev:
let
    roscomvpn-geosite = prev.fetchurl {
        url = "https://github.com/hydraponique/roscomvpn-geosite/releases/download/202604152235/geosite.dat";
        hash = "sha256-dluG5Lau1doaIGMEtVAMdmhof6HfjoMiyKSWHhtnIZA=";
    };
    roscomvpn-geoip = prev.fetchurl {
        url = "https://github.com/hydraponique/roscomvpn-geoip/releases/download/202605110648/geoip.dat";
        hash = "sha256-jHnwCGVVw5MqdhdFsVh1RKF5vxy6cONxpyAUTN2j1Jo=";
    };

    roscomvpn-assets = prev.runCommand "roscomvpn-assets" {} ''
        mkdir -p $out/share/v2ray

        cp ${roscomvpn-geoip} $out/share/v2ray/geoip.ru.dat
        cp ${roscomvpn-geosite} $out/share/v2ray/geosite.ru.dat
    '';
in
{
    xray = prev.xray.override {
        assets = [
            prev.v2ray-geoip
            prev.v2ray-domain-list-community
            roscomvpn-assets
        ];
    };
}
