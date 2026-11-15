"""Minimal MCP server exposing a SearXNG instance as a web_search tool."""

import os

import httpx
from mcp.server.fastmcp import FastMCP
from mcp.server.transport_security import TransportSecuritySettings

SEARXNG_URL = os.environ.get("SEARXNG_URL", "http://127.0.0.1:8888")

# Extra browser origins allowed through DNS-rebinding protection, e.g. the
# llama.cpp web UI opened from another device and proxied via /cors-proxy.
EXTRA_ORIGINS = os.environ.get("MCP_ALLOWED_ORIGINS", "").split()

mcp = FastMCP(
    "searxng",
    host=os.environ.get("MCP_HOST", "127.0.0.1"),
    port=int(os.environ.get("MCP_PORT", "8889")),
    stateless_http=True,
    json_response=True,
    transport_security=TransportSecuritySettings(
        enable_dns_rebinding_protection=True,
        allowed_hosts=["127.0.0.1:*", "localhost:*", "[::1]:*"],
        allowed_origins=[
            "http://127.0.0.1:*",
            "http://localhost:*",
            "http://[::1]:*",
            *EXTRA_ORIGINS,
        ],
    ),
)


@mcp.tool()
async def web_search(
    query: str,
    max_results: int = 10,
    language: str = "auto",
    time_range: str | None = None,
    categories: str = "general",
) -> str:
    """Search the web via SearXNG.

    Args:
        query: Search query.
        max_results: Number of results to return (1-30).
        language: Result language code, e.g. "en", "ru", or "auto".
        time_range: Optional recency filter: "day", "month" or "year".
        categories: SearXNG categories, e.g. "general", "news", "it".
    """
    params = {
        "q": query,
        "format": "json",
        "language": language,
        "categories": categories,
    }
    if time_range:
        params["time_range"] = time_range

    async with httpx.AsyncClient(timeout=30) as client:
        resp = await client.get(f"{SEARXNG_URL}/search", params=params)
        resp.raise_for_status()
        data = resp.json()

    results = data.get("results", [])[: max(1, min(max_results, 30))]
    if not results:
        return f"No results for: {query}"

    lines = []
    for i, r in enumerate(results, 1):
        lines.append(f"{i}. {r.get('title', '').strip()}")
        lines.append(f"   {r.get('url', '')}")
        if r.get("publishedDate"):
            lines.append(f"   published: {r['publishedDate']}")
        content = (r.get("content") or "").strip()
        if content:
            lines.append(f"   {content}")
    return "\n".join(lines)


def main():
    mcp.run(transport="streamable-http")


if __name__ == "__main__":
    main()
