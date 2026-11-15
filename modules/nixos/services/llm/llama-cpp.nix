{ lib, pkgs, ... }:
{
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-vulkan;
    host = "127.0.0.1";
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
      # 262144 also fits, but leaves only ~130 MiB of the RX 570's 4 GiB VRAM.
      "-c"
      "131072"
      "-ctk"
      "q8_0"
      "-ctv"
      "q8_0"
      "--jinja"
      # Lets the web UI reach the local SearXNG MCP bridge without CORS.
      "--ui-mcp-proxy"

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
    serviceConfig.RestartSec = lib.mkForce 5;
  };
}
