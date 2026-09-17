# n8n Master Grok Bot (plugin)

Grok plugin that turns a bot into an n8n control plane. Docs MCP is bundled. Instance MCP is not. Token is not bundled. Production writes are not the default.

Install from the marketplace repo root:

```bash
grok plugin marketplace add /path/to/n8n-master-grok-bot
grok plugin install n8n-master-grok-bot --trust
```

Then paste `AGENT_INSTALL.md` into the bot, with your n8n HTTPS origin on the last line.

Read `SECURITY.md` before exposing a real workflow. First execute is a read-only canary.

## Licenses

- Official n8n skills: Apache-2.0 (`docs/LICENSE-n8n-official-skills-Apache-2.0.txt`)
- Community skills: MIT (`docs/LICENSE-community-skills-MIT.txt`)
- Original commerce/inventory skill, setup skill, packaging: Apache-2.0
