# Local patches

The complete upstream skill directories are bundled from the commits in `SOURCE_LOCK.txt`.

Two sibling reference files are copied into `n8n-agents-official/references/` to work around upstream issue #44, which reports that single-skill packagers fail on those cross-skill paths:

- `AGENT_TOOL_BINARY.md` from `n8n-binary-and-data-official/references/`
- `COMMS_NODES.md` from `n8n-node-configuration-official/references/`

No upstream instruction text is otherwise changed. The custom `n8n-commerce-inventory-master` skill is original to this template.

The current n8n monorepo `.agents/skills/` set is also bundled at the commit in `SOURCE_LOCK.txt`. These are repository-engineering skills (node development, OAuth additions, public API, database migrations, endpoint protection, telemetry, UI/content/conventions, tests and PR workflows), not substitutes for the production workflow skills.

Canonical skill files live in `plugins/n8n-master-grok-bot/skills/`. `.grok/skills` is a relative symlink to that directory so Grok Build in this folder and marketplace plugin install share one tree.

The original `n8n-master-setup` skill is part of this template. It documents Bitwarden secret name mapping, canary-first MCP exposure, and the difference between instance-level MCP and the MCP Server Trigger node. It does not change upstream skill text.
