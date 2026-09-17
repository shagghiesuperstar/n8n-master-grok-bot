#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
python3 - "$root" <<'PY'
import pathlib, re, sys
root=pathlib.Path(sys.argv[1])
skills=(root/'.grok/skills').resolve()
plugin_skills=(root/'plugins/n8n-master-grok-bot/skills').resolve()
errors=[]
names={}
if not skills.exists():
    errors.append('missing .grok/skills')
if plugin_skills.exists() and skills != plugin_skills:
    errors.append(f'.grok/skills does not resolve to plugin skills ({skills} vs {plugin_skills})')
for f in skills.glob('*/SKILL.md'):
    text=f.read_text(errors='strict')
    if not text.startswith('---\n'):
        errors.append(f'{f}: missing YAML frontmatter')
        continue
    parts=text.split('---',2)
    if len(parts)<3: errors.append(f'{f}: unclosed frontmatter'); continue
    m=re.search(r'^name:\s*[\'\"]?([^\n\'\"]+)',parts[1],re.M)
    if not m: errors.append(f'{f}: missing name'); continue
    name=m.group(1).strip()
    if name in names: errors.append(f'duplicate skill name {name}: {names[name]} and {f}')
    names[name]=f
required={'using-n8n-skills-official','n8n-workflow-lifecycle-official','n8n-credentials-and-security-official','n8n-data-tables-official','n8n-debugging-official','n8n-commerce-inventory-master','n8n-master-setup'}
for n in sorted(required-set(names)): errors.append(f'missing required skill: {n}')
for rel in ['AGENTS.md','AGENT_INSTALL.md','SECURITY.md','.grok/config.toml','scripts/connect-n8n.sh','scripts/update-skills.sh','.grok-plugin/marketplace.json','plugins/n8n-master-grok-bot/plugin.json']:
    if not (root/rel).exists(): errors.append(f'missing {rel}')
if errors:
    print('\n'.join(errors),file=sys.stderr); raise SystemExit(1)
print(f'PASS: {len(names)} unique skills; required files present.')
PY
if command -v grok >/dev/null; then
  (cd "$root" && grok inspect)
else
  echo "INFO: grok not installed here; skipped live discovery check."
fi
