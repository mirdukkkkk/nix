{ lib, pkgs, ... }:
{
  services.searx = {
    enable = true;
    # Scrapers break as sites change; 26.05's snapshot (2026-05) has no
    # working Google engine, unstable ships `google cse`.
    package = pkgs.unstable.searxng;
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
      # Tested 2026-11 both via the proxy and directly: `google cse` gives
      # relevant results in any language. Bing answers Cyrillic queries with
      # random pages and geolocates to the proxy exit, so it stays off; the
      # rest return CAPTCHA/403 or fail to parse and only add timeouts.
      engines =
        map
          (name: {
            inherit name;
            disabled = true;
          })
          [
            "bing"
            "brave"
            "duckduckgo"
            "google"
            "mojeek"
            "qwant"
            "startpage"
            "yandex"
          ]
        ++ [
          {
            name = "google cse";
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
    # searxng keeps sqlite caches in $TMPDIR under fixed names; a private
    # /tmp keeps other searxng processes from owning those files.
    serviceConfig.PrivateTmp = true;
  };
}
