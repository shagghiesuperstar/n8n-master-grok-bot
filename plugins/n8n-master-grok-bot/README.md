# n8n Master Grok Bot (plugin)

Grok plugin for n8n control-plane work: official workflow skills, n8n monorepo engineering skills, community supplement, commerce/inventory master, and live official n8n docs MCP.

This plugin does **not** bundle an n8n instance token. It does **not** default to production writes. Connect the instance MCP yourself after install. Prove a read-only canary before exposing any other workflow.

## Install (from this marketplace repo)

```bash
grok plugin marketplace add /path/to/n8n-master-grok-bot
grok plugin install n8n-master-grok-bot --trust
```

Then enable it in `/plugins` if it is not already on. Load skill `n8n-master-setup`.

## Connect an n8n instance

Grok Build is not in n8n's OAuth client list. Use **Settings > Instance-level MCP > Connect > API key**.

```bash
export N8N_MCP_ACCESS_TOKEN=your-n8n-mcp-api-key
./scripts/connect-n8n.sh https://YOUR-N8N-DOMAIN
grok mcp doctor
```

Optional Bitwarden Secrets Manager: store the same key as `N8N_MCP`, then map it to `N8N_MCP_ACCESS_TOKEN`. Never put the token in git or chat.

Canary-first: enable **Available in MCP** only on a read-only canary. Run `/n8n-master-readiness`, then execute the canary with `executionMode=manual` and expect `{ok:true,canary:true}`. Keep production write workflows off MCP.

MCP Server Trigger nodes are a different feature. This plugin uses instance-level MCP.

## First prompt

```text
/n8n-master-readiness
```

## Licenses

- Official n8n skills: Apache-2.0 (`docs/LICENSE-n8n-official-skills-Apache-2.0.txt`)
- Community skills: MIT (`docs/LICENSE-community-skills-MIT.txt`)
- Original commerce/inventory skill, setup skill, and this packaging: Apache-2.0 unless noted in `docs/LOCAL_PATCHES.md`
