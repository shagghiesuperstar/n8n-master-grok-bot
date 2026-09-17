#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
echo "This replaces bundled skill directories with current upstream content. Review diffs before commit."
read -r -p "Continue? [y/N] " answer
[[ "$answer" == "y" || "$answer" == "Y" ]] || exit 0
git clone --depth 1 https://github.com/n8n-io/skills.git "$tmp/official"
git clone --depth 1 https://github.com/czlonkowski/n8n-skills.git "$tmp/community"
git clone --depth 1 --filter=blob:none --sparse https://github.com/n8n-io/n8n.git "$tmp/n8n"
git -C "$tmp/n8n" sparse-checkout set .agents/skills
for d in "$tmp/official"/skills/* "$tmp/community"/skills/* "$tmp/n8n"/.agents/skills/*; do
  name="$(basename "$d")"
  [[ "$name" == "n8n-commerce-inventory-master" ]] && continue
  rm -rf "$root/.grok/skills/$name"
  cp -R "$d" "$root/.grok/skills/$name"
done
cp "$tmp/official/skills/n8n-binary-and-data-official/references/AGENT_TOOL_BINARY.md" "$root/.grok/skills/n8n-agents-official/references/"
cp "$tmp/official/skills/n8n-node-configuration-official/references/COMMS_NODES.md" "$root/.grok/skills/n8n-agents-official/references/"
{
  echo "official=$(git -C "$tmp/official" rev-parse HEAD)"
  echo "community=$(git -C "$tmp/community" rev-parse HEAD)"
  echo "n8n_monorepo=$(git -C "$tmp/n8n" rev-parse HEAD)"
  date -u '+updated_utc=%Y-%m-%dT%H:%M:%SZ'
} > "$root/SOURCE_LOCK.txt"
"$root/scripts/verify.sh"
echo "Updated. Inspect the git diff and rerun Grok readiness tests before accepting."
