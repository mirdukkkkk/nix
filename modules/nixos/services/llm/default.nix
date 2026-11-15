# Local LLM stack, started on demand: `systemctl start llama-cpp` also brings
# up SearXNG and the MCP bridge that gives the web UI a web_search tool.
{
  imports = [
    ./llama-cpp.nix
    ./searxng.nix
    ./searxng-mcp.nix
  ];
}
