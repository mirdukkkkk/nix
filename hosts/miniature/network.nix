{
    networking = {
        useDHCP = false;
        dhcpcd.enable = false;

        interfaces.enp7s0 = {
            ipv4.addresses = [
                {
                    address = "192.168.1.100";
                    prefixLength = 24;
                }
            ];
        };
        defaultGateway = "192.168.1.1";
        nameservers = [ "192.168.1.1" ];

        firewall.enable = true;
    };
}
