{
    imports = [ ./tproxy.nix ];

    services.xray = {
        enable = true;
        settings = let
            log = builtins.fromJSON(builtins.readFile ./config/log.json);
            dns = builtins.fromJSON(builtins.readFile ./config/dns.json);
            inbounds = builtins.fromJSON(builtins.readFile ./config/inbounds.json);
            outbounds = builtins.fromJSON(builtins.readFile ./config/outbounds.json);
            routing = builtins.fromJSON(builtins.readFile ./config/routing.json);
        in {
            inherit log dns inbounds outbounds routing;
        };
    };
}
