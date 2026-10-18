#!/usr/bin/env bash
# Cohérence des fichiers du plugin : JSON, chemins cités par le skill, copies partagées, syntaxe des scripts.
. "$(dirname "$0")/lib/assert.sh"

echo "== Fichiers du plugin"

for f in "$ROOT/.claude-plugin/marketplace.json" "$PB/.claude-plugin/plugin.json" "$IP/templates/claude/settings.json"; do
  json_ok "$f"
  case $? in
    0) ok_case "JSON valide : ${f#"$ROOT"/}" ;;
    1) ko_case "JSON valide : ${f#"$ROOT"/}" "JSON invalide" ;;
    *) printf '  --   %s non vérifié : ni node, ni python, ni jq\n' "${f#"$ROOT"/}" ;;
  esac
done

# La version n'est écrite que dans plugin.json, qui fait foi sur l'entrée de la marketplace.
if grep -q '"version"' "$ROOT/.claude-plugin/marketplace.json"; then
  ko_case "version unique" "retire « version » de .claude-plugin/marketplace.json : plugin.json fait foi"
elif grep -q -E '"version"[[:space:]]*:[[:space:]]*"[0-9]+\.[0-9]+\.[0-9]+"' "$PB/.claude-plugin/plugin.json"; then
  ok_case "version unique dans plugin.json"
else
  ko_case "version unique" "plugin.json n'a pas de version x.y.z"
fi

# Chaque chemin de fichier cité par le skill existe dans le plugin.
missing=""
for doc in "$IP/SKILL.md" "$IP/references/maquettes.md" "$IP/references/questionnaire.md"; do
  # Chemins relatifs au skill seulement : « .claude/scripts/… » désigne un fichier du projet généré.
  for ref in $(grep -o -E '(^|[^A-Za-z0-9_./-])(templates|examples|references|scripts)/[A-Za-z0-9_./-]+' "$doc" \
      | sed -E 's/^[^A-Za-z0-9_./-]//; s/[.)]+$//' | sort -u); do
    [ -e "$IP/$ref" ] || missing="$missing ${doc#"$IP"/}→$ref"
  done
done
if [ -z "$missing" ]; then ok_case "chemins cités par le skill"; else ko_case "chemins cités par le skill" "introuvables :$missing"; fi

# L'exemple de maquettes embarque une copie des fichiers communs du modèle.
for f in index.html proto.js components.css; do
  if cmp -s "$IP/templates/design/$f" "$IP/examples/maquettes-canettes/$f"; then
    ok_case "copie identique dans l'exemple : $f"
  else
    ko_case "copie identique dans l'exemple : $f" "templates/design/$f et examples/maquettes-canettes/$f diffèrent : recopie le modèle dans l'exemple"
  fi
done

while IFS= read -r f; do
  if bash -n "$f" 2>/dev/null; then ok_case "syntaxe bash : ${f#"$ROOT"/}"; else ko_case "syntaxe bash : ${f#"$ROOT"/}" "$(bash -n "$f" 2>&1)"; fi
done < <(find "$ROOT" -name '*.sh' -not -path '*/.git/*' | sort)

if command -v claude >/dev/null 2>&1; then
  expect "claude plugin validate" 0 "Validation passed" -- claude plugin validate "$PB"
else
  printf '  --   claude plugin validate non lancé : CLI claude absent\n'
fi

summary
