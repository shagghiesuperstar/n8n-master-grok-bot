#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 https://your-n8n-domain" >&2
  echo "Set N8N_MCP_ACCESS_TOKEN to the n8n Instance-level MCP API key first." >&2
  echo "Optional: Bitwarden Secrets Manager secret named N8N_MCP, then map it to N8N_MCP_ACCESS_TOKEN." >&2
  echo "Noninteractive: CONNECT_N8N_YES=1 $0 https://your-n8n-domain" >&2
  exit 64
fi
url="${1%/}"
case "$url" in
  https://*) ;;
  *) echo "Refusing non-HTTPS remote URL: $url" >&2; exit 65 ;;
esac
command -v grok >/dev/null || { echo "grok is not installed or not in PATH" >&2; exit 69; }
if [[ -z "${N8N_MCP_ACCESS_TOKEN:-}" && -n "${N8N_MCP:-}" ]]; then
  export N8N_MCP_ACCESS_TOKEN="${N8N_MCP}"
fi
if [[ -z "${N8N_MCP_ACCESS_TOKEN:-}" ]]; then
  echo "N8N_MCP_ACCESS_TOKEN is unset." >&2
  echo "In n8n: Settings > Instance-level MCP > Connect > API key (Grok is not in the OAuth client list)." >&2
  echo "Store the key outside git. Optional BWS key name: N8N_MCP." >&2
  echo "export N8N_MCP_ACCESS_TOKEN then re-run. Do not put the token in this repo or in chat." >&2
  exit 78
fi
endpoint="$url/mcp-server/http"
echo "Premortem: wrong tenant or a write-capable token can change live workflows."
echo "Indicator: grok mcp doctor shows an unexpected host, or execute/publish tools appear for production write workflows."
echo "Containment: project-scoped MCP; token via N8N_MCP_ACCESS_TOKEN placeholder, never written into git."
echo "Rollback: grok mcp remove --scope project n8n-instance; rotate the API key in n8n Settings > Instance-level MCP."
echo "CANARY-FIRST: in n8n, enable Available in MCP only on a read-only canary workflow. Leave production write workflows off MCP."
echo "MCP Server Trigger nodes are a different feature. This script wires instance-level MCP only."
echo "Default is not production-write. Do not execute, publish, or update workflows until /n8n-master-readiness PASSes and the canary returns {ok:true,canary:true}."
if [[ "${CONNECT_N8N_YES:-}" == "1" ]]; then
  answer=y
else
  read -r -p "Add project-scoped n8n MCP endpoint $endpoint? [y/N] " answer
fi
[[ "$answer" == "y" || "$answer" == "Y" ]] || exit 0
# Keep the placeholder in project config so the secret is not committed.
grok mcp add --scope project --transport http n8n-instance "$endpoint" \
  --header 'Authorization: Bearer ${N8N_MCP_ACCESS_TOKEN}'
echo "Added. Run: grok mcp doctor && grok inspect"
echo "Next: /n8n-master-readiness then execute only the canary workflow (executionMode=manual)."
