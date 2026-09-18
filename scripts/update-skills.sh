#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
echo "Replaces bundled official + community skill directories with current upstream."
echo "Does not bundle n8n-io monorepo contributor skills. Review diffs before commit."
read -r -p "Continue? [y/N] " answer
[[ "$answer" == "y" || "$answer" == "Y" ]] || exit 0
git clone --depth 1 https://github.com/n8n-io/skills.git "$tmp/official"
git clone --depth 1 https://github.com/czlonkowski/n8n-skills.git "$tmp/community"
if [[ -d "$root/skills" ]]; then
  dest="$root/skills"
else
  dest="$root/.grok/skills"
fi
keep_local="n8n-commerce-inventory-master n8n-master-setup"
for d in "$tmp/official"/skills/* "$tmp/community"/skills/*; do
  name="$(basename "$d")"
  case " $keep_local " in
    *" $name "*) continue ;;
  esac
  rm -rf "$dest/$name"
  cp -R "$d" "$dest/$name"
done
cp "$tmp/official/skills/n8n-binary-and-data-official/references/AGENT_TOOL_BINARY.md" "$dest/n8n-agents-official/references/"
cp "$tmp/official/skills/n8n-node-configuration-official/references/COMMS_NODES.md" "$dest/n8n-agents-official/references/"
{
  echo "official=$(git -C "$tmp/official" rev-parse HEAD)"
  echo "community=$(git -C "$tmp/community" rev-parse HEAD)"
  echo "n8n_monorepo_bundled=no"
  date -u '+updated_utc=%Y-%m-%dT%H:%M:%SZ'
} > "$root/SOURCE_LOCK.txt"
if [[ -x "$root/scripts/verify.sh" ]]; then
  "$root/scripts/verify.sh"
fi
echo "Updated. Inspect the git diff before accepting."
