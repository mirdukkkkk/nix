{ pkgs, ... }:
{
    systemd.services.tproxy = {
        description = "Xray TProxy routing";

        wantedBy = [ "multi-user.target" "xray.service" ];

        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
        };

        script = ''
            ${pkgs.iproute2}/bin/ip rule add fwmark 1 table 100 || true
            ${pkgs.iproute2}/bin/ip route add local 0.0.0.0/0 dev lo table 100 || true

            ${pkgs.iproute2}/bin/ip -6 rule add fwmark 1 table 106 || true
            ${pkgs.iproute2}/bin/ip -6 route add local ::/0 dev lo table 106 || true
        '';

        postStop = ''
            ${pkgs.iproute2}/bin/ip rule del fwmark 1 table 100 || true
            ${pkgs.iproute2}/bin/ip route del local 0.0.0.0/0 dev lo table 100 || true

            ${pkgs.iproute2}/bin/ip -6 rule del fwmark 1 table 106 || true
            ${pkgs.iproute2}/bin/ip -6 route del local ::/0 dev lo table 106 || true
        '';
    };

    networking.nftables.ruleset = ''
        table inet xray {
            chain prerouting {
                type filter hook prerouting priority filter; policy accept;
                ip daddr { 100.64.0.0/10, 127.0.0.0/8, 169.254.0.0/16, 224.0.0.0/4, 255.255.255.255 } return
                meta l4proto tcp ip daddr 192.168.0.0/16 return
                ip daddr 192.168.0.0/16 udp dport != 53 return
                ip6 daddr { ::1, fe80::/10 } return
                meta l4proto tcp ip6 daddr fd00::/8 return
                ip6 daddr fd00::/8 udp dport != 53 return
                meta mark 0x000000ff return
                meta l4proto { tcp, udp } meta mark set 0x00000001 tproxy ip to 127.0.0.1:12345 accept
                meta l4proto { tcp, udp } meta mark set 0x00000001 tproxy ip6 to [::1]:12345 accept
            }

            chain output {
                type route hook output priority filter; policy accept;
                ip daddr { 100.64.0.0/10, 127.0.0.0/8, 169.254.0.0/16, 224.0.0.0/4, 255.255.255.255 } return
                meta l4proto tcp ip daddr 192.168.0.0/16 return
                ip daddr 192.168.0.0/16 udp dport != 53 return
                ip6 daddr { ::1, fe80::/10 } return
                meta l4proto tcp ip6 daddr fd00::/8 return
                ip6 daddr fd00::/8 udp dport != 53 return
                meta mark 0x000000ff return
                meta l4proto { tcp, udp } meta mark set 0x00000001 accept
            }

            chain divert {
                type filter hook prerouting priority mangle; policy accept;
                meta l4proto tcp socket transparent 1 meta mark set 0x00000001 accept
            }
        }
    '';
}
