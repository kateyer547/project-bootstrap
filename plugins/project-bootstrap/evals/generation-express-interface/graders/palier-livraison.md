---
type: regex
pattern: '^## Palier [0-9]+ — [^\n]*[Ll]ivraison[\s\S]*release-check'
flags: m
target:
  source: file
  path: docs/11-paliers.md
---
