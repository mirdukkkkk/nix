{ lib, ... }:
{
  services.searx = {
    enable = true;
    # SEARX_SECRET_KEY=...; generate with `openssl rand -hex 32`.
    environmentFile = "/persist/.secrets/searx.env";
    settings = {
      server = {
        bind_address = "127.0.0.1";
        port = 8888;
        secret_key = "$SEARX_SECRET_KEY";
        # Only the local MCP bridge talks to it, no bot protection needed.
        limiter = false;
      };
      search.formats = [
        "html"
        "json"
      ];
      # Route every engine request through the local xray SOCKS inbound;
      # socks5h resolves DNS on the proxy side too.
      outgoing.proxies."all://" = [ "socks5h://127.0.0.1:1080" ];
      # Through the proxy exit IP DuckDuckGo/Startpage/Brave/Google answer
      # with CAPTCHA or 403; Bing (disabled upstream by default) still works.
      engines = [
        {
          name = "bing";
          disabled = false;
        }
      ];
    };
  };

  systemd.services.searx = {
    wantedBy = lib.mkForce [ ];
    partOf = [ "llama-cpp.service" ];
    wants = [ "xray.service" ];
    after = [ "xray.service" ];
  };
}
