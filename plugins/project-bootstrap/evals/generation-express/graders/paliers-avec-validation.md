---
type: regex
pattern: '^## Palier 1 — [\s\S]*```(bash|sh)'
flags: m
target:
  source: file
  path: docs/11-paliers.md
---
