---
type: regex
pattern: '\{\{[A-Z0-9_]+\}\}'
match: not_contains
target:
  source: file
  path: ".claude/skills/build-app/SKILL.md"
---
