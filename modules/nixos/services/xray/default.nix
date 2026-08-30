{ lib, pkgs, ... }:
let
    roscomvpn-geosite = pkgs.fetchurl {
        url = "https://github.com/hydraponique/roscomvpn-geosite/releases/download/202604152235/geosite.dat";
        hash = "sha256-dluG5Lau1doaIGMEtVAMdmhof6HfjoMiyKSWHhtnIZA=";
    };
    roscomvpn-geoip = pkgs.fetchurl {
        url = "https://github.com/hydraponique/roscomvpn-geoip/releases/download/202605110648/geoip.dat";
        hash = "sha256-jHnwCGVVw5MqdhdFsVh1RKF5vxy6cONxpyAUTN2j1Jo=";
    };

    inbounds = builtins.fromJSON (builtins.readFile ./config/inbounds.json);

    roscomvpn-assets = pkgs.runCommand "roscomvpn-assets" {} ''
        mkdir -p $out/share/v2ray

        cp ${roscomvpn-geoip} $out/share/v2ray/geoip.ru.dat
        cp ${roscomvpn-geosite} $out/share/v2ray/geosite.ru.dat
    '';
in
{
    imports = [ ./tproxy.nix ];

    options.my.services.xray.tproxyPort = lib.mkOption {
        type = lib.types.port;
        default = (lib.findFirst (i: i.tag == "tproxy") null inbounds).port;
        defaultText = lib.literalMD "the port of the inbound tagged `tproxy` from `config/inbounds.json`";
        description = ''
            Port that nftables redirects traffic to. Defaults to the
            value from the xray config itself, so the ruleset and the
            inbound can't drift apart.
        '';
    };

    config = {
        services.xray = {
            enable = true;
            package = pkgs.xray.override {
                assets = [
                    pkgs.v2ray-geoip
                    pkgs.v2ray-domain-list-community
                    roscomvpn-assets
                ];
            };
            settings = let
                log = builtins.fromJSON(builtins.readFile ./config/log.json);
                dns = builtins.fromJSON(builtins.readFile ./config/dns.json);
                outbounds = builtins.fromJSON(builtins.readFile ./config/outbounds.json);
                routing = builtins.fromJSON(builtins.readFile ./config/routing.json);
            in {
                inherit log dns inbounds outbounds routing;
            };
        };
    };
}
