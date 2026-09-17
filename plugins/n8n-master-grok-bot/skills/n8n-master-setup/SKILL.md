---
name: n8n-master-setup
description: Use when installing this Grok plugin, wiring n8n Instance-level MCP, loading N8N_MCP from Bitwarden, or proving canary-first safety before any workflow write.
when-to-use: n8n setup install plugin MCP N8N_MCP Bitwarden BWS canary marketplace connect
user-invocable: true
metadata:
  author: Grok n8n Master Template
  short-description: Canary-first n8n MCP setup for Grok
---

# n8n Master setup (canary-first)

Load this skill before connecting an n8n instance. Official n8n docs and live MCP schemas outrank this file.

This plugin does **not** ship an n8n token and does **not** default to production writes.

## Install

From the marketplace repo root:

```bash
grok plugin marketplace add .
grok plugin install n8n-master-grok-bot --trust
```

Then `/n8n-master-readiness`. Docs MCP should PASS. Instance MCP should FAIL until you connect.

## Token (never in git or chat)

Grok is not in n8n's OAuth client list. Use **Settings > Instance-level MCP > Connect > API key**.

Export the key as `N8N_MCP_ACCESS_TOKEN`. Do not paste it into chat, skills, workflow text, or this repo.

Optional Bitwarden Secrets Manager:

- Secret **name** (key): `N8N_MCP`
- Map it: `export N8N_MCP_ACCESS_TOKEN="FAKESECRET_u2v3w4x5y6z7a8b9c0d1"`
- Or `bws run` into a child process. Never print `bws secret get`.

`N8N_MCP` and `N8N_MCP_ACCESS_TOKEN` are the same credential. The connect script copies `N8N_MCP` into `N8N_MCP_ACCESS_TOKEN` when the latter is unset.

## Connect instance MCP

HTTPS instance origin only (no path). Example: `https://YOUR-WORKSPACE.app.n8n.cloud`

```bash
export N8N_MCP_ACCESS_TOKEN
./scripts/connect-n8n.sh https://YOUR-N8N-DOMAIN
```

Noninteractive: `CONNECT_N8N_YES=1 ./scripts/connect-n8n.sh https://YOUR-N8N-DOMAIN`

The script writes **project** scope `./.grok/config.toml` with header `Authorization: Bearer ${N8N_MCP_ACCESS_TOKEN}`. Confirm the file contains the placeholder, not the raw key.

`grok mcp doctor` must show `n8n-instance` handshake OK. Rotate the key if the URL is wrong.

## MCP scope (two different features)

1. **Instance-level MCP** (this plugin): Settings > Instance-level MCP. Per-workflow **Available in MCP**. Project/folder **Manage MCP access**. Eligible workflows need a Webhook, Form, Schedule, or Chat trigger (or a published canary with a Manual Trigger that you execute with `executionMode=manual`).
2. **MCP Server Trigger node**: n8n *serving* MCP to other clients. Not a substitute for instance-level MCP. Do not enable it for this bot unless the user explicitly wants n8n to expose tools outbound.

Grok cannot whitelist MCP tools the way some other clients can. **n8n Available in MCP is the blast-radius control.** Search may preview workflows the user can see; `get_workflow_details` / execute / update require Available in MCP.

## Canary-first (required)

Before exposing any production workflow:

1. Create a disposable workflow named `MCP-CANARY-READONLY`.
2. Manual Trigger -> Code node that returns `{ ok: true, canary: true }` only. No credentials, no HTTP, no writes.
3. Enable **Available in MCP** on that workflow **only**. Production write workflows stay off.
4. `/n8n-master-readiness` — instance MCP must PASS.
5. `execute_workflow` with `workflowId` + `executionMode=manual`. Expect `{ok:true,canary:true}`.
6. Only then consider exposing additional **non-production** workflows. Production catalog, payments, PII, DNS, secrets, and Zoho/Medusa writes stay off MCP until a human GO.

If search lists production workflows but `get_workflow_details` says "not available in MCP", that is correct. Do not enable them to "make search tidy."

## Defaults (do not weaken)

- No production-write default.
- No `--always-approve` / `--yolo` in bot instructions.
- No token in `plugin.json`, `.mcp.json`, skills, or git.
- Plugin `.mcp.json` ships **n8n-docs only**.
- Do not edit, publish, or execute WF-style production flows from this control plane without explicit approval.

## Rollback

`grok mcp remove --scope project n8n-instance`

Rotate the Instance-level MCP API key. Leave production workflows' Available in MCP off.
