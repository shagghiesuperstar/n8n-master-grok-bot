# n8n Master Grok Bot

This plugin turns a Grok Bot into an n8n control plane: live official docs, official workflow skills, and (after you connect it) your n8n instance over HTTP MCP.

It does not host n8n, it does not ship a token, and it will not write production workflows unless you expose them and say so.

## Why install it

Grok is not in n8n's OAuth client list, and Grok cannot whitelist MCP tools. Most n8n+AI setups either commit a token or expose every workflow. This one keeps the token as an env placeholder, ships **docs MCP only**, and treats **Available in MCP** as the real wall. You prove a read-only canary before anything else.

## Who it's for

People who already run n8n (Cloud or HTTPS self-host) and want a Grok Bot to inspect, design, and test workflows.

## What it will not do

- Will not SSH into n8n or your laptop.
- Will not publish itself to the public Grok marketplace.
- Will not enable production write workflows on MCP (payments, catalog, ERP, PII).
- Will not put secrets in git or chat.
- Will not read workflow bodies until you mark them Available in MCP. It **can** still see workflow names.

## 60-second install

```bash
curl -fsSL https://x.ai/cli/install.sh | bash   # skip if grok already works
git clone https://github.com/shagghiesuperstar/n8n-master-grok-bot.git
cd n8n-master-grok-bot
./scripts/verify.sh
grok plugin marketplace add .
grok plugin install n8n-master-grok-bot --trust
```

In n8n: Settings → Instance-level MCP → on. Use the **API key** tab (not OAuth). Store the key in your environment as `N8N_MCP` or `N8N_MCP_ACCESS_TOKEN`. Do not paste it into chat or this repo.

## Point your Grok Bot here

Open a new Grok Bot. Paste the entire file `AGENT_INSTALL.md`. Put your n8n HTTPS origin on the last line (no path, example `https://YOUR-WORKSPACE.app.n8n.cloud`).

The bot clones/installs, wires HTTP MCP, proves a read-only canary, and stops. You should not have to run the leftover commands yourself.

Then read `SECURITY.md` before you expose any real workflow.
