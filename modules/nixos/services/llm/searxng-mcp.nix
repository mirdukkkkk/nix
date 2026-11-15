{ lib, pkgs, ... }:
{
  # Add http://127.0.0.1:8889/mcp in the llama.cpp web UI (Settings -> MCP).
  systemd.services.searxng-mcp = {
    description = "MCP bridge exposing SearXNG as a web_search tool";
    partOf = [ "llama-cpp.service" ];
    wants = [ "searx.service" ];
    after = [ "searx.service" ];
    environment = {
      SEARXNG_URL = "http://127.0.0.1:8888";
      MCP_HOST = "127.0.0.1";
      MCP_PORT = "8889";
      # The web UI opened from the phone; its Origin is forwarded by
      # llama-server's /cors-proxy.
      MCP_ALLOWED_ORIGINS = "http://192.168.1.100:8080";
    };
    serviceConfig = {
      ExecStart = lib.getExe pkgs.searxng-mcp;
      Restart = "on-failure";

      DynamicUser = true;
      CapabilityBoundingSet = "";
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
      SystemCallFilter = [ "@system-service" ];
    };
  };
}
