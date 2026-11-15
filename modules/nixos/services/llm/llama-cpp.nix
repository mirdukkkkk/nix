{ lib, pkgs, ... }:
{
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-vulkan;
    # Reachable from the LAN (phone); the firewall opens it on enp42s0 only.
    host = "0.0.0.0";
    port = 8080;
    # Kept outside the nix store and the HF cache; /persist survives the
    # tmpfs root, and the file must be world-readable for the DynamicUser.
    model = "/persist/llm/models/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-Q4_K_M.gguf";
    extraFlags = [
      # Attention + shared weights on the GPU, MoE experts on the CPU.
      "-ngl"
      "99"
      "--n-cpu-moe"
      "99"
      "-t"
      "8"
      # Single slot so the whole context belongs to one chat.
      "-np"
      "1"
      # Measured on the RX 570 (4 GiB): up to 65536 generation runs at ~14.5
      # t/s; from ~98304 VRAM overflows and it drops to ~10.5 t/s, prompt
      # processing halves.
      "-c"
      "65536"
      "-ctk"
      "q8_0"
      "-ctv"
      "q8_0"
      "-fa"
      "on"
      "--jinja"
      # Lets the web UI reach the local SearXNG MCP bridge without CORS.
      "--ui-mcp-proxy"
      # Required once it listens on the LAN: without it /cors-proxy (from
      # --ui-mcp-proxy) is an open proxy for anyone on the network.
      "--api-key-file"
      "/run/credentials/llama-cpp.service/api-key"

      # Sampling recommended for this model.
      "--temp"
      "1.0"
      "--top-p"
      "0.95"
      "--top-k"
      "20"
      "--min-p"
      "0"
      "--presence-penalty"
      "1.5"
    ];
  };

  systemd.services.llama-cpp = {
    # Started by hand: `systemctl start llama-cpp`.
    wantedBy = lib.mkForce [ ];
    wants = [ "searxng-mcp.service" ];
    # HOME is / for the DynamicUser, so Mesa can't create ~/.cache and runs
    # without a shader cache, recompiling every pipeline after each start.
    environment.MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp/mesa";
    serviceConfig = {
      RestartSec = lib.mkForce 5;
      # Root-only file; LoadCredential hands a copy to the DynamicUser.
      # Generate with `tr -dc a-zA-Z0-9 </dev/urandom | head -c40`.
      LoadCredential = [ "api-key:/persist/.secrets/llama-api-key" ];
    };
  };

  networking.firewall.interfaces.enp42s0.allowedTCPPorts = [ 8080 ];
}
