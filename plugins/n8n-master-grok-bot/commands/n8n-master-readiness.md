---
name: n8n-master-readiness
description: Run a read-only n8n master readiness audit. Use when starting this plugin, after connecting an n8n instance MCP, or when the user says /n8n-master-readiness.
---

Run the n8n master readiness audit. Do not mutate anything.

Verify loaded rules, skills, docs MCP, n8n instance MCP, permissions, current n8n version, available workflow-builder tools, credentials metadata access, and test capability.

Return PASS/FAIL per layer, blockers, and one next action.

Load `using-n8n-skills-official` first, then `n8n-master-setup` if instance MCP is not yet connected.

Do not create, update, publish, or execute workflows during this audit.

After instance MCP connects: confirm only a read-only canary is Available in MCP. Production write workflows must remain off MCP. The first authorized execute is the canary (`executionMode=manual`) expecting `{ok:true,canary:true}`.
