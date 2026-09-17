# n8n Master Grok Bot

A single Grok Build workspace plus a copy-paste hosted Grok Bot charter that routes across official n8n skills, a broad community supplement, live n8n documentation, the target instance MCP, and a production commerce/inventory skill.

## Included

- 14 official n8n skills: 13 capability modules plus the official router.
- 23 repository-native n8n engineering skills from the current `n8n-io/n8n` monorepo.
- 15 community skills from `czlonkowski/n8n-skills`, subordinate to official sources.
- One original commerce/inventory master skill.
- One setup skill (`n8n-master-setup`): BWS/`N8N_MCP` mapping, canary-first safety, MCP scope.
- Live official n8n docs MCP.
- Secure script to add a project-scoped n8n instance MCP (token placeholder only).
- Deterministic source lock, update script, local integrity check, and license files.

## Install

1. Install Grok Build if needed:

   ```bash
   curl -fsSL https://x.ai/cli/install.sh | bash
   ```

2. Unzip this workspace, enter it, and verify discovery:

   ```bash
   cd n8n-master-grok-bot
   ./scripts/verify.sh
   ```

3. In n8n, enable **Settings > Instance-level MCP**. Use least privilege. Expose **only** a read-only canary workflow until that canary returns `{ok:true,canary:true}`.

   Grok Build is not in n8n's OAuth client list (Claude, Cursor, VS Code, etc.). Use the **API key** tab: copy the Server URL and personal access token. Store the token outside git as `N8N_MCP_ACCESS_TOKEN`. Optional Bitwarden Secrets Manager key name: `N8N_MCP`. Do not put it in this repo or in chat.

4. Connect this workspace (HTTPS instance URL, no path):

   ```bash
   export N8N_MCP_ACCESS_TOKEN
   ./scripts/connect-n8n.sh https://YOUR-N8N-DOMAIN
   grok mcp doctor
   grok inspect
   ```

   Confirm `.grok/config.toml` contains `Bearer ${N8N_MCP_ACCESS_TOKEN}`, not the raw key.

   Prove the bot on the canary first, then on other **non-production** n8n workflows. Only then consider live production workflows, and never enable production write workflows on MCP without an explicit human GO.

5. Start Grok in this directory:

   ```bash
   grok
   ```

6. First prompt:

   ```text
   /n8n-master-readiness
   ```

## Safe update

```bash
./scripts/update-skills.sh
```

Review the diff and source commits. Do not auto-accept new community code, hooks, or MCP servers.

## Important limit

No static bundle contains every current community skill or every SaaS API. "Hypercurrent" comes from the live official docs MCP and target-instance schema discovery. This bundle includes the complete official workflow skill pack and one broad, actively maintained community pack; additional community packages require explicit supply-chain review.

## Marketplace (Grok plugin)

This repository is a Grok marketplace with one plugin, `n8n-master-grok-bot`. Skills live in `plugins/n8n-master-grok-bot/skills/`; `.grok/skills` is a symlink so Grok Build in this folder still works.

Validate locally, then add and install. Do not publish to the public Grok marketplace until a human owner does it. Do not treat production-write MCP exposure as a default.

```bash
grok plugin validate ./plugins/n8n-master-grok-bot
grok plugin marketplace add .
grok plugin install n8n-master-grok-bot --trust
```

The plugin ships the official n8n **docs** MCP only. Connect the instance MCP with `./scripts/connect-n8n.sh` after install. After a git remote exists:

```bash
grok plugin marketplace add https://YOUR-GIT-HOST/YOUR-ORG/n8n-master-grok-bot.git
```

## Hosted Grok Bot path

Use `GROK-BOT-INSTRUCTIONS.md` as the Bot charter. At `grok.com/connectors`, add the official docs MCP (`https://docs.n8n.io/~gitbook/mcp`) and your HTTPS n8n instance MCP URL ending in `/mcp-server/http`. Authenticate with the n8n **API key** (Bearer token); Grok is not in n8n's OAuth client dropdown. Restrict which workflows/agents are exposed. Import/install the bundled skills through Grok's supported Plugins/Skills UI where available.

Hosted Grok Bot custom MCP connectors must be internet-reachable. Do not tunnel an unauthenticated n8n MCP endpoint. Canary-first, then non-production, then production only with a human GO.

## MCP scope reminder

- Instance-level MCP (this repo) is not the MCP Server Trigger node.
- Per-workflow **Available in MCP** is the blast-radius control.
- Project/folder **Manage MCP access** can bulk-toggle. Leave production write workflows off.
