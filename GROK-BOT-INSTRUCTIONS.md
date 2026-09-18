# Hosted Grok Bot

Paste `AGENT_INSTALL.md` as the first message. Put the n8n HTTPS origin on the last line. Do not paste the API key.

Product goal: this repo is a public template; marketplace publish is intended. Scrub tenant/secrets before publish.

After install, follow `AGENTS.md` and `SECURITY.md`.

Connectors (grok.com/connectors), HTTP only:

- Docs: `https://docs.n8n.io/~gitbook/mcp`
- Instance: `https://YOUR-N8N-DOMAIN/mcp-server/http` with the Instance-level MCP API key (Bearer). Grok is not in n8n's OAuth list.

The instance URL must be HTTPS and authenticated. Do not expose an unauthenticated MCP. Do not SSH.
