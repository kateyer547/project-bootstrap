---
type: regex
pattern: '\{\{[A-Z0-9_]+\}\}'
match: not_contains
target:
  source: file
  path: "claude-config/skills/build-app/SKILL.md"
---
