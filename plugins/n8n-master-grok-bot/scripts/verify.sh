#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
python3 - "$root" <<'PY'
import pathlib, re, sys
root=pathlib.Path(sys.argv[1])
skills=root/'skills'
errors=[]
names={}
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
for rel in ['plugin.json','AGENTS.md','GROK-BOT-INSTRUCTIONS.md','AGENT_INSTALL.md','SECURITY.md','.mcp.json','commands/n8n-master-readiness.md']:
    if not (root/rel).exists(): errors.append(f'missing {rel}')
if errors:
    print('\n'.join(errors),file=sys.stderr); raise SystemExit(1)
print(f'PASS: {len(names)} unique plugin skills; required plugin files present.')
PY
