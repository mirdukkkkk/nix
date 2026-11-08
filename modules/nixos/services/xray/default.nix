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

  # nixpkgs xray reads assets from share/xray, while the v2fly packages
  # install into share/v2ray, so everything is copied into one place here.
  xray-assets = pkgs.runCommand "xray-geo-assets" { } ''
    mkdir -p $out/share/xray

    cp ${pkgs.unstable.v2ray-geoip}/share/v2ray/{geoip,private}.dat $out/share/xray/
    cp ${pkgs.unstable.v2ray-domain-list-community}/share/v2ray/geosite.dat $out/share/xray/

    cp ${roscomvpn-geoip} $out/share/xray/geoip.ru.dat
    cp ${roscomvpn-geosite} $out/share/xray/geosite.ru.dat
  '';

  xray = pkgs.unstable.xray.override {
    assets = [ xray-assets ];
  };

  configPath = "/etc/xray/config.json";
in
{
  imports = [ ./tproxy.nix ];

  options.my.services.xray.tproxyPort = lib.mkOption {
    type = lib.types.port;
    default = 12345;
    description = ''
      Port that nftables redirects traffic to. Must match the
      `tproxy` inbound port in the xray config at ${configPath}.
    '';
  };

  config = {
    # ${configPath} holds the full xray config (log/dns/inbounds/outbounds/routing),
    # including VLESS auth UUIDs. Managed imperatively on the host, never in the
    # nix store or git. Preserved across reboots since /etc is tmpfs here.
    preservation.preserveAt."/persist".files = [
      {
        file = configPath;
        mode = "0600";
      }
    ];

    services.xray = {
      enable = true;
      package = xray;
      settingsFile = configPath;
    };
  };
}
