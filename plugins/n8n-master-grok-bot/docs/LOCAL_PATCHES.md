# Local patches

Bundled from commits in `SOURCE_LOCK.txt`.

Copied into `n8n-agents-official/references/` to work around upstream issue #44:

- `AGENT_TOOL_BINARY.md` from `n8n-binary-and-data-official/references/`
- `COMMS_NODES.md` from `n8n-node-configuration-official/references/`

Canonical skills live in `plugins/n8n-master-grok-bot/skills/`. `.grok/skills` is a relative symlink to that directory.

Original to this template: `n8n-commerce-inventory-master`, `n8n-master-setup`, `AGENT_INSTALL.md`, `SECURITY.md`.

n8n-io monorepo contributor skills (create-pr, Linear, Loom, Nathan, editor UI, etc.) are not bundled. They are for hacking n8n itself, not for operating an instance. `scripts/update-skills.sh` refreshes official + community packs only.
