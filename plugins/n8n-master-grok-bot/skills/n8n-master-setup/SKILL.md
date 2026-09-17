---
name: n8n-master-setup
description: Use when installing this Grok plugin, wiring n8n Instance-level MCP, loading N8N_MCP from Bitwarden, or proving canary-first safety before any workflow write.
when-to-use: n8n setup install plugin MCP N8N_MCP Bitwarden BWS canary marketplace connect
user-invocable: true
metadata:
  author: Grok n8n Master Template
  short-description: Canary-first n8n MCP setup for Grok
---

# n8n Master setup

Official docs and live MCP schemas outrank this file. Read `SECURITY.md` in this plugin for the threat model.

This plugin does not ship an n8n token and does not default to production writes.

## Install

From the marketplace repo root:

```bash
grok plugin marketplace add .
grok plugin install n8n-master-grok-bot --trust
```

Or paste `AGENT_INSTALL.md` into the bot and let it finish.

`/n8n-master-readiness` — docs MCP should PASS. Instance MCP FAIL until connected.

## Token

Grok is not in n8n's OAuth list. Settings → Instance-level MCP → API key.

Env name: `N8N_MCP` (alias `N8N_MCP_ACCESS_TOKEN`). Optional Bitwarden name: `N8N_MCP`. Prefer `bws run --`. Never print the value.

## Connect

HTTPS origin only, no path:

```bash
CONNECT_N8N_YES=1 ./scripts/connect-n8n.sh https://YOUR-N8N-DOMAIN
```

Confirm project config has a Bearer env placeholder, not a raw key. `grok mcp doctor` → `n8n-instance` handshake OK. Redact doctor output.

## Wall

Grok cannot whitelist tools. **Available in MCP** is the wall. Search may still show names.

Canary first: `MCP-CANARY-READONLY`, `{ok:true,canary:true}`, `executionMode=manual`. Production write workflows stay off MCP.

Rollback: `grok mcp remove --scope project n8n-instance`, then turn Available in MCP off, then rotate the key.
