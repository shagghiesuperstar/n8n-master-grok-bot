Copy this whole file into a new Grok Bot. Replace the last line with your real n8n HTTPS origin. Do not paste the API key into the chat.

---

You are installing and proving n8n-master-grok-bot for this human. Finish the job. Do not dump a plan and wait.

Repo: https://github.com/shagghiesuperstar/n8n-master-grok-bot

Rules:
- HTTPS MCP only. Never SSH. Never tunnel an unauthenticated MCP.
- Never print secrets, tokens, Authorization headers, or secret-manager JSON.
- Never public-publish this plugin to the Grok marketplace.
- Never enable production write workflows on MCP (payments, catalog, ERP, personal data).
- Never use --always-approve or --yolo.
- If blocked, stop with BLOCKED and exactly one human action.

Do this, in order:

1. Clone the repo if this workspace is not already it. cd into it.
2. Run `./scripts/verify.sh`. It must PASS.
3. Run `grok plugin marketplace add .` then `grok plugin install n8n-master-grok-bot --trust`. Already-configured / already-installed is success.
4. Confirm the token is already in the environment as `N8N_MCP` or `N8N_MCP_ACCESS_TOKEN`. Do not echo it. If it is missing, BLOCKED: tell the human to set that env var from n8n Settings → Instance-level MCP → API key, then re-run you. Do not ask them to paste the key into chat.
5. Wire instance MCP:
   `CONNECT_N8N_YES=1 ./scripts/connect-n8n.sh https://N8N_ORIGIN`
   Use the origin the human put on the last line of this prompt. HTTPS only, no path.
6. Prove `.grok/config.toml` contains a Bearer env placeholder and does not contain a raw key. Redact `grok mcp doctor` before showing it. n8n-instance handshake must be OK.
7. Tell the human, once: in n8n, create `MCP-CANARY-READONLY` = Manual Trigger → Code that returns only `{ok:true,canary:true}` (no credentials, no HTTP). Enable **Available in MCP** on that workflow only. Leave every production workflow off.
8. When they say the canary is on MCP, run `/n8n-master-readiness` (read-only). Then `execute_workflow` with that workflowId and `executionMode=manual`. Poll `get_workflow_execution` with `includeData: true` until you see `{ok:true,canary:true}`.
9. Confirm `get_workflow_details` on any production workflow id still says it is not available in MCP. Do not flip those toggles to tidy search.
10. Stop. Report: plugin installed, doctor OK (redacted), canary execution id, production workflows still off MCP.

After success, follow `AGENTS.md`. Official `*-official` skills beat community skills.

N8N_ORIGIN=https://YOUR-N8N-DOMAIN
