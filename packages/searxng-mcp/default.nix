{ writers, python3Packages }:
writers.writePython3Bin "searxng-mcp" {
  libraries = with python3Packages; [
    httpx
    mcp
  ];
  flakeIgnore = [ "E501" ];
} (builtins.readFile ./searxng_mcp.py)
