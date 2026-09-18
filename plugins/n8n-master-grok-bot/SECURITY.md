# Security

Grok cannot limit which MCP tools it may call. If you mark a workflow **Available in MCP**, the bot can call it.

## Instance MCP sees workflow names

`search_workflows` can preview names and ids for workflows the API key can list, even when those workflows are **not** Available in MCP.

That is not the same as access. `get_workflow_details`, update, publish, and execute fail until Available in MCP is on.

Do not turn Available in MCP on just to make search look tidy.

## Available in MCP is the real wall

Grok's `mcp add` has no tool allowlist. execute/update/publish are present once the instance is connected.

The wall is in n8n:

- Per-workflow **Available in MCP**
- Project/folder **Manage MCP access** if you use it
- The API key's own permission

Eligible workflows usually need a Webhook, Form, Schedule, or Chat trigger. A Manual Trigger canary is fine if you execute it with `executionMode=manual`.

Instance-level MCP (this plugin) is not the MCP Server Trigger node. Do not mix them up.

## Canary-first

Before any real workflow:

1. `MCP-CANARY-READONLY`: Manual Trigger → Code `{ok:true,canary:true}` only. No credentials, no HTTP, no writes.
2. Available in MCP on that workflow **only**.
3. `execute_workflow` with `executionMode=manual`. Read the execution with `includeData: true`. Expect `{ok:true,canary:true}`.
4. Then, maybe, other **non-production** workflows.

If the canary is not green, stop.

## No production-write defaults

This plugin ships **n8n-docs MCP only**. Instance MCP is something you add later.

Defaults:

- No production execute/publish/update
- No `--always-approve` / `--yolo`
- Payments, catalog, personal data, DNS, and secrets stay off MCP until a human says so in that chat

## Secrets never in this repo

Grok is not in n8n's OAuth client dropdown. Use the Instance-level MCP **API key**.

Store it outside git as `N8N_MCP` (alias `N8N_MCP_ACCESS_TOKEN`). If you use a secret manager, keep the value out of the shell transcript (`bws run --` is one way).

`.grok/config.toml` must keep `Authorization: Bearer ${N8N_MCP_ACCESS_TOKEN}` as a placeholder. If a raw key lands in git, rotate the key in n8n and treat the commit as a leak.

Never put tokens in README, skills, workflow text fields, or chat.

## Rollback / uninstall

```bash
grok mcp remove --scope project n8n-instance
grok plugin uninstall n8n-master-grok-bot
```

Then: turn **Available in MCP** off on every workflow you exposed, and rotate the Instance-level MCP API key.

Removing the plugin does not un-expose workflows. The toggles in n8n are the wall; they stay where you left them.
