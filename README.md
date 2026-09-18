# n8n Master Grok Bot

This plugin lets a Grok Bot read live n8n docs and, after you connect it, talk to your n8n instance over HTTPS.

It does not host n8n, does not ship an API key, and will not change production workflows unless you expose them and ask.

## Why install it

n8n has no Grok OAuth button, and Grok cannot limit which MCP tools it may call. Typical kits either commit a token or open every workflow. This one keeps the key in your environment, ships **docs MCP only**, and treats n8n's **Available in MCP** toggle as the wall. You prove a dummy canary before anything real.

## Who it's for

People who already run n8n (Cloud or HTTPS self-host) and want a Grok Bot to inspect, design, and test workflows.

## What it will not do

- Will not SSH into n8n or your laptop.
- Public template + Grok marketplace publish is the product goal. Scrub all tenant data and secrets before any publish.
- Will not enable production write workflows on MCP (payments, catalog, ERP, personal data).
- Will not put secrets in git or chat.
- Will not read workflow bodies until you mark them Available in MCP. It **can** still see workflow names.

## 60-second install

If you want the bot to do this, skip to the next section.

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

The bot clones if needed, installs, wires HTTPS MCP, proves a read-only canary, and stops.

Then read `SECURITY.md` before you expose any real workflow.
