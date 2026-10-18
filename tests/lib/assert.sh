#!/usr/bin/env bash
# Fonctions communes aux tests. À sourcer : . "$(dirname "$0")/lib/assert.sh"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PB="$ROOT/plugins/project-bootstrap"
IP="$PB/skills/init-project"
VERIFY="$IP/scripts/verify-bootstrap.sh"

passed=0
failed=0

# Dossier temporaire du fichier de test, supprimé à la fin.
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

ok_case() { passed=$((passed + 1)); printf '  ok   %s\n' "$1"; }

ko_case() {
  failed=$((failed + 1))
  printf '  ÉCHEC %s : %s\n' "$1" "$2"
  [ -n "${3:-}" ] && printf '%s\n' "$3" | sed 's/^/         | /'
}

# expect <nom> <code attendu> [motif…] -- <commande…>
# Lance la commande, vérifie son code de sortie et la présence de chaque motif
# (expression régulière étendue) dans sa sortie. Un motif préfixé par « ! » doit être absent.
expect() {
  local name=$1 want=$2
  shift 2
  local patterns=()
  while [ $# -gt 0 ] && [ "$1" != "--" ]; do patterns+=("$1"); shift; done
  shift
  local out code
  out=$("$@" 2>&1)
  code=$?
  if [ "$code" -ne "$want" ]; then
    ko_case "$name" "code de sortie $code au lieu de $want" "$out"
    return
  fi
  local p
  for p in "${patterns[@]}"; do
    if [ "${p#!}" != "$p" ]; then
      if printf '%s\n' "$out" | grep -q -E -- "${p#!}"; then
        ko_case "$name" "motif présent alors qu'il devrait être absent : ${p#!}" "$out"
        return
      fi
    elif ! printf '%s\n' "$out" | grep -q -E -- "$p"; then
      ko_case "$name" "motif absent : $p" "$out"
      return
    fi
  done
  ok_case "$name"
}

# Remplace dans un fichier, sans dépendre de « sed -i » (absent ou différent selon les systèmes).
edit_file() {
  local file=$1 expr=$2
  sed "$expr" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
}

# Valide un fichier JSON avec node, python ou jq. Code 2 si aucun outil n'est disponible.
json_ok() {
  if node -e '' >/dev/null 2>&1; then
    node -e 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))' "$1" >/dev/null 2>&1
    return $?
  fi
  local py
  for py in python3 python py; do
    if "$py" -c 'import json' >/dev/null 2>&1; then
      "$py" -c 'import json, sys; json.load(open(sys.argv[1], encoding="utf-8"))' "$1" >/dev/null 2>&1
      return $?
    fi
  done
  if command -v jq >/dev/null 2>&1; then jq empty "$1" >/dev/null 2>&1; return $?; fi
  return 2
}

# Dossier bin/ ne contenant que les commandes listées, pour simuler un poste
# sans node, python ni jq. Des scripts relais gardent les vrais exécutables
# à leur place (sous Windows, git.exe a besoin des DLL de son dossier).
restricted_bin() {
  local dir=$1 c p
  shift
  mkdir -p "$dir"
  for c in "$@"; do
    p=$(command -v "$c") || continue
    printf '#!/bin/sh\nexec "%s" "$@"\n' "$p" > "$dir/$c"
    chmod +x "$dir/$c"
  done
}

# Affiche le bilan et renvoie un code non nul en cas d'échec.
summary() {
  printf '  -- %d réussi(s), %d échec(s)\n' "$passed" "$failed"
  [ "$failed" -eq 0 ]
}
