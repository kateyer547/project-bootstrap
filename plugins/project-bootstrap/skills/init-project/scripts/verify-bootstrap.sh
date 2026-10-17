#!/usr/bin/env bash
# Vérifie que le cadrage généré par init-project est complet et exploitable.
# À lancer depuis la racine du projet. Code de sortie 0 = tout est bon.

set -u
ROOT="${1:-.}"
cd "$ROOT" || { echo "Dossier introuvable : $ROOT"; exit 2; }

errors=0
ok()   { printf '  OK   %s\n' "$1"; }
fail() { printf '  KO   %s\n' "$1"; errors=$((errors + 1)); }

echo "== Fichiers attendus"
required=(
  CLAUDE.md
  PLAN.md
  .env.example
  docs/00-index.md
  docs/01-vision.md
  docs/02-specifications-fonctionnelles.md
  docs/03-stack-technique.md
  docs/04-donnees.md
  docs/05-modele-donnees.md
  docs/06-architecture.md
  docs/07-securite.md
  docs/08-infrastructure.md
  docs/09-deploiement.md
  docs/10-qualite-tests.md
  docs/11-paliers.md
  .claude/settings.json
  .claude/skills/build-app/SKILL.md
  .claude/agents/tier-reviewer.md
)
for f in "${required[@]}"; do
  if [ -s "$f" ]; then ok "$f"; else fail "$f manquant ou vide"; fi
done

echo "== Marqueurs non remplis"
present=()
for f in "${required[@]}"; do [ -f "$f" ] && present+=("$f"); done
if [ -d docs/adr ]; then
  while IFS= read -r f; do present+=("$f"); done < <(find docs/adr -name '*.md' ! -name '0000-modele.md')
fi
leftovers=$(grep -n -E '\{\{[^}]*\}\}' "${present[@]}" 2>/dev/null || true)
if [ -z "$leftovers" ]; then ok "aucun marqueur {{...}} restant"; else
  fail "marqueurs {{...}} restants :"; echo "$leftovers" | head -30 | sed 's/^/         /'
fi
helpers=$(grep -l -F 'AIDE :' "${present[@]}" 2>/dev/null || true)
if [ -z "$helpers" ]; then ok "aucun commentaire d'aide restant"; else
  fail "commentaires d'aide (AIDE :) restants dans : $(echo "$helpers" | tr '\n' ' ')"
fi

echo "== Configuration Claude"
if [ -f .claude/settings.json ]; then
  if python3 -c 'import json,sys; json.load(open(sys.argv[1]))' .claude/settings.json 2>/dev/null; then
    ok ".claude/settings.json est un JSON valide"
  else
    fail ".claude/settings.json n'est pas un JSON valide"
  fi
fi
for f in .claude/skills/build-app/SKILL.md .claude/agents/tier-reviewer.md; do
  [ -f "$f" ] || continue
  if head -1 "$f" | grep -q '^---$' && grep -q '^name:' "$f" && grep -q '^description:' "$f"; then
    ok "$f a un frontmatter valide"
  else
    fail "$f : frontmatter (name, description) absent ou incomplet"
  fi
done

echo "== Modèle de données"
if [ -f docs/05-modele-donnees.md ]; then
  if grep -q 'erDiagram' docs/05-modele-donnees.md; then ok "diagramme erDiagram présent"; else fail "pas de diagramme Mermaid erDiagram dans docs/05-modele-donnees.md"; fi
fi

echo "== Paliers"
if [ -f docs/11-paliers.md ]; then
  tiers=$(grep -c -E '^## Palier [0-9]+' docs/11-paliers.md || true)
  if [ "$tiers" -gt 0 ]; then ok "$tiers palier(s) défini(s)"; else fail "aucune section '## Palier N' dans docs/11-paliers.md"; fi
  # Chaque palier doit contenir au moins un bloc de commandes de validation.
  missing=$(awk '
    /^## Palier [0-9]+/ { if (name != "" && !cmd) print name; name=$0; cmd=0; next }
    /^## / { if (name != "" && !cmd) print name; name=""; next }
    /^```(bash|sh|shell|powershell|pwsh)/ { cmd=1 }
    END { if (name != "" && !cmd) print name }
  ' docs/11-paliers.md)
  if [ -z "$missing" ]; then ok "chaque palier a un bloc de commandes de validation"; else
    fail "paliers sans bloc de commandes de validation :"; echo "$missing" | sed 's/^/         /'
  fi
fi

echo "== Traçabilité fonctionnalités → paliers"
if [ -f docs/02-specifications-fonctionnelles.md ] && [ -f docs/11-paliers.md ]; then
  features=$(grep -o -E '\bF-[0-9]{2,3}\b' docs/02-specifications-fonctionnelles.md | sort -u)
  if [ -z "$features" ]; then
    fail "aucun identifiant F-xx dans docs/02-specifications-fonctionnelles.md"
  else
    uncovered=""
    for id in $features; do
      grep -q -E "\b$id\b" docs/11-paliers.md || uncovered="$uncovered $id"
    done
    if [ -z "$uncovered" ]; then ok "toutes les fonctionnalités ($(echo "$features" | wc -l | tr -d ' ')) sont rattachées à un palier"
    else fail "fonctionnalités absentes de docs/11-paliers.md :$uncovered"; fi
  fi
fi

echo "== Maquettes"
if [ -d design ]; then
  for f in design/index.html design/ecrans.js design/tokens.css design/components.css design/proto.js docs/12-maquettes.md; do
    if [ -s "$f" ]; then ok "$f"; else fail "$f manquant ou vide"; fi
  done
  design_files=$(find design -type f \( -name '*.html' -o -name '*.css' -o -name '*.js' \) ! -path 'design/captures/*' 2>/dev/null)
  if [ -f design/ecrans/_modele.html ]; then fail "design/ecrans/_modele.html ne doit pas être copié dans le projet"; fi
  # shellcheck disable=SC2086
  left=$(grep -n -E '\{\{[^}]*\}\}' $design_files docs/12-maquettes.md 2>/dev/null || true)
  if [ -z "$left" ]; then ok "maquettes sans marqueur {{...}}"; else
    fail "marqueurs {{...}} restants dans les maquettes :"; echo "$left" | head -15 | sed 's/^/         /'
  fi
  # shellcheck disable=SC2086
  aide=$(grep -l -F 'AIDE :' $design_files docs/12-maquettes.md 2>/dev/null || true)
  if [ -z "$aide" ]; then ok "maquettes sans commentaire d'aide"; else fail "commentaires d'aide restants dans : $(echo "$aide" | tr '\n' ' ')"; fi
  if [ -f design/ecrans.js ]; then
    screens=$(grep -o -E 'fichier:[[:space:]]*"[^"]+"' design/ecrans.js | sed -E 's/.*"([^"]+)"/\1/')
    if [ -z "$screens" ]; then fail "aucun écran déclaré dans design/ecrans.js"; else
      count=0; missing_screens=""
      for s in $screens; do
        count=$((count + 1))
        [ -f "design/$s" ] || missing_screens="$missing_screens $s"
      done
      if [ -z "$missing_screens" ]; then ok "$count écran(s) déclaré(s), tous présents"; else fail "écrans déclarés mais absents :$missing_screens"; fi
    fi
  fi
  # Liens internes entre écrans
  broken=""
  for page in design/ecrans/*.html; do
    [ -f "$page" ] || continue
    for target in $(grep -o -E 'href="[^"#?:]+\.html' "$page" | sed 's/href="//'); do
      [ -f "$(dirname "$page")/$target" ] || broken="$broken $(basename "$page")→$target"
    done
  done
  if [ -z "$broken" ]; then ok "tous les liens entre écrans aboutissent"; else fail "liens cassés :$broken"; fi
  # Fonctionnalités MVP visibles dans au moins un écran (avertissement seulement)
  if [ -f docs/02-specifications-fonctionnelles.md ] && [ -f docs/12-maquettes.md ]; then
    nomock=""
    for id in $(grep -o -E '\bF-[0-9]{2,3}\b' docs/02-specifications-fonctionnelles.md | sort -u); do
      grep -q -E "\b$id\b" docs/12-maquettes.md design/ecrans.js 2>/dev/null || nomock="$nomock $id"
    done
    [ -n "$nomock" ] && printf '  INFO fonctionnalités sans écran (normal si elles n%sont pas d%sinterface) :%s\n' "'" "'" "$nomock"
  fi
else
  ok "pas de dossier design/ (application sans interface)"
fi

echo "== Secrets"
suspects=""
for f in .env.example CLAUDE.md docs/*.md; do
  [ -f "$f" ] || continue
  # Filtre appliqué au contenu de la ligne seulement (pas au nom du fichier).
  hits=$(grep -n -i -E '(password|passwd|secret|api[_-]?key|token)[[:space:]]*[:=][[:space:]]*["'\'']?[A-Za-z0-9/+_.-]{8,}' "$f" \
    | grep -v -i -E ':.*(changeme|example|exemple|<[^>]*>|xxx|\$\{)' || true)
  [ -n "$hits" ] && suspects="$suspects$(echo "$hits" | sed "s|^|$f:|")"$'\n'
done
suspects=$(echo "$suspects" | sed '/^$/d')
if [ -z "$suspects" ]; then ok "aucun secret apparent"; else
  fail "valeurs ressemblant à des secrets :"; echo "$suspects" | head -10 | sed 's/^/         /'
fi

echo
if [ "$errors" -eq 0 ]; then
  echo "Cadrage complet : prêt pour build-app."
  exit 0
else
  echo "$errors problème(s) à corriger."
  exit 1
fi
