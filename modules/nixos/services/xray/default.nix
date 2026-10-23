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

  roscomvpn-assets = pkgs.runCommand "roscomvpn-assets" { } ''
    mkdir -p $out/share/v2ray

    cp ${roscomvpn-geoip} $out/share/v2ray/geoip.ru.dat
    cp ${roscomvpn-geosite} $out/share/v2ray/geosite.ru.dat
  '';

  # Pinned newer than nixpkgs. `assets` goes through `override` (it is a
  # callPackage argument), the version bump through `overrideAttrs`.
  xray =
    (pkgs.unstable.xray.override {
      assets = [
        pkgs.unstable.v2ray-geoip
        pkgs.unstable.v2ray-domain-list-community
        roscomvpn-assets
      ];
    }).overrideAttrs
      (finalAttrs: {
        version = "26.10.21";
        src = pkgs.fetchFromGitHub {
          owner = "XTLS";
          repo = "Xray-core";
          rev = "v${finalAttrs.version}";
          hash = "sha256-1FwcB/qZaH7W9b+GSe+CG/s+uStaDjz792OxDc3uAyg=";
        };
        vendorHash = "sha256-o4mKfCGgI4r5ZatnA4AsK4zR0/qOl2qpqCmoJmE2jBQ=";
      });

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
