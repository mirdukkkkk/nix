{
    networking = {
        networkmanager.enable = true;
        nftables.enable = true;
        iproute2.enable = true;

        firewall = {
            enable = true;
            allowedTCPPorts = [ 22 ];
        };
    };
}
