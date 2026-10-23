#!/usr/bin/env bash
# Vérifie que le cadrage généré par init-project est complet et exploitable.
# À lancer depuis la racine du projet. Code de sortie 0 = tout est bon.

set -u
ROOT="${1:-.}"
cd "$ROOT" || { echo "Dossier introuvable : $ROOT"; exit 2; }

errors=0
ok()   { printf '  OK   %s\n' "$1"; }
fail() { printf '  KO   %s\n' "$1"; errors=$((errors + 1)); }
info() { printf '  INFO %s\n' "$1"; }

# Valide un fichier JSON avec le premier interpréteur qui fonctionne réellement
# (sous Windows, « python3 » peut n'être qu'un raccourci vers le Microsoft Store).
# Code 0 = valide, 1 = invalide, 2 = aucun outil disponible.
json_valid() {
  if node -e '' >/dev/null 2>&1; then
    node -e 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))' "$1" >/dev/null 2>&1
    return $?
  fi
  for py in python3 python py; do
    if "$py" -c 'import json' >/dev/null 2>&1; then
      "$py" -c 'import json, sys; json.load(open(sys.argv[1], encoding="utf-8"))' "$1" >/dev/null 2>&1
      return $?
    fi
  done
  if command -v jq >/dev/null 2>&1; then
    jq empty "$1" >/dev/null 2>&1
    return $?
  fi
  return 2
}

# Identifiants des fonctionnalités MVP de docs/02 : sections « ### F-xx — Nom »
# dont la ligne « Priorité » n'indique pas explicitement V2, V3… ou « Plus tard ».
# Une priorité absente ou inattendue compte comme MVP, pour ne rien laisser passer.
mvp_features() {
  awk '
    { sub(/\r$/, "") }
    /^### F-[0-9]+/ { flush(); match($0, /F-[0-9]+/); id = substr($0, RSTART, RLENGTH); prio = ""; next }
    /^(#|##|###) / { flush(); next }
    id != "" && /Priorit/ { prio = toupper($0) }
    END { flush() }
    function flush() { if (id != "" && prio !~ /V[2-9]|PLUS TARD|LATER/) print id; id = "" }
  ' "$1" | sort -u
}

echo "== Fichiers attendus"
required=(
  CLAUDE.md
  PLAN.md
  .env.example
  .gitignore
  docs/00-index.md
  docs/01-vision.md
  docs/02-specifications-fonctionnelles.md
  docs/03-stack-technique.md
  docs/04-donnees.md
  docs/05-modele-donnees.md
  docs/06-architecture.md
  docs/07-securite.md
  docs/11-paliers.md
  .claude/settings.json
  .claude/skills/build-app/SKILL.md
  .claude/skills/fix-bug/SKILL.md
  .claude/skills/add-feature/SKILL.md
  .claude/agents/tier-reviewer.md
  .claude/scripts/verify-spec.sh
  .claude/hooks/session-start.sh
  .claude/hooks/guard-tests.sh
)
for f in "${required[@]}"; do
  if [ -s "$f" ]; then ok "$f"; else fail "$f manquant ou vide"; fi
done

echo "== Marqueurs non remplis"
# /dev/null : sans aucun fichier, grep lirait l'entrée standard (et bash 3.2 refuse un tableau vide avec set -u).
present=(/dev/null)
for f in "${required[@]}"; do
  # Ce script lui-même, recopié dans le projet, contient les motifs qu'il recherche.
  [ "$f" = .claude/scripts/verify-spec.sh ] && continue
  [ -f "$f" ] && present+=("$f")
done
if [ -d docs/adr ]; then
  while IFS= read -r f; do present+=("$f"); done < <(find docs/adr -name '*.md' ! -name '0000-modele.md')
fi
[ -f .claude/hooks/format-file.sh ] && present+=(.claude/hooks/format-file.sh)
[ -f docs/13-integrations.md ] && present+=(docs/13-integrations.md)
leftovers=$(grep -n -E '\{\{[^}]*\}\}' "${present[@]}" 2>/dev/null || true)
if [ -z "$leftovers" ]; then ok "aucun marqueur {{...}} restant"; else
  fail "marqueurs {{...}} restants :"; echo "$leftovers" | head -30 | sed 's/^/         /'
fi
helpers=$(grep -l -F 'AIDE :' "${present[@]}" 2>/dev/null || true)
if [ -z "$helpers" ]; then ok "aucun commentaire d'aide restant"; else
  fail "commentaires d'aide (AIDE :) restants dans : $(echo "$helpers" | tr '\n' ' ')"
fi

echo "== Dépôt git"
if ! command -v git >/dev/null 2>&1; then
  fail "git introuvable : build-app en a besoin (branches, tags tier-N)"
elif git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  ok "dépôt git initialisé"
  if git check-ignore -q .env; then ok ".env est ignoré par git"; else fail ".env n'est pas ignoré par git (ou déjà versionné) : voir .gitignore"; fi
  if git check-ignore -q .env.example; then fail ".env.example est ignoré par git alors qu'il doit être versionné"; else ok ".env.example est versionné"; fi
else
  fail "le dossier n'est pas un dépôt git : lancer git init -b <branche principale>"
fi

echo "== Configuration Claude"
if [ -f .claude/settings.json ]; then
  json_valid .claude/settings.json
  case $? in
    0) ok ".claude/settings.json est un JSON valide" ;;
    1) fail ".claude/settings.json n'est pas un JSON valide" ;;
    *) info ".claude/settings.json non vérifié : ni node, ni python, ni jq disponible" ;;
  esac
fi
if [ -f .claude/settings.json ]; then
  # Garde-fous attendus dans les permissions.
  grep -q -F 'Edit(/.claude/**)' .claude/settings.json && ok "modification de .claude/ soumise à confirmation" \
    || fail ".claude/settings.json : règle ask « Edit(/.claude/**) » absente"
  grep -q -F -- '--no-verify' .claude/settings.json && ok "contournement des hooks git (--no-verify) interdit" \
    || fail ".claude/settings.json : règle deny sur --no-verify absente"
  grep -q -E '"Write\([^)]' .claude/settings.json && fail ".claude/settings.json : règle Write(<chemin>) ignorée par Claude Code, utiliser Edit(<chemin>)"
  # Chaque script de .claude/hooks/ est déclaré dans settings.json, et inversement.
  for h in .claude/hooks/*.sh; do
    [ -f "$h" ] || continue
    grep -q -F "$h" .claude/settings.json && ok "$h déclaré dans settings.json" || fail "$h n'est déclaré dans aucun hook de settings.json"
  done
  for h in $(grep -o -E '\.claude/hooks/[A-Za-z0-9_.-]+\.sh' .claude/settings.json | sort -u); do
    [ -f "$h" ] || fail "settings.json déclare $h, qui n'existe pas"
  done
fi
for f in .claude/skills/build-app/SKILL.md .claude/skills/fix-bug/SKILL.md .claude/skills/add-feature/SKILL.md .claude/agents/tier-reviewer.md; do
  [ -f "$f" ] || continue
  if head -1 "$f" | grep -q '^---$' && grep -q '^name:' "$f" && grep -q '^description:' "$f"; then
    ok "$f a un frontmatter valide"
  else
    fail "$f : frontmatter (name, description) absent ou incomplet"
  fi
done

echo "== Contrat d'outillage"
if [ -f docs/03-stack-technique.md ]; then
  if grep -q "^## Contrat d'outillage" docs/03-stack-technique.md; then ok "contrat d'outillage présent dans docs/03"
  else fail "pas de section « ## Contrat d'outillage » dans docs/03-stack-technique.md"; fi
fi
if [ -f CLAUDE.md ]; then
  if grep -q -i "tout vérifier" CLAUDE.md; then ok "CLAUDE.md donne la commande « Tout vérifier »"
  else fail "CLAUDE.md : ligne « Tout vérifier » (cible check du lanceur de tâches) absente"; fi
fi

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

echo "== Traçabilité spécification → paliers"
spec=docs/02-specifications-fonctionnelles.md
if [ -f "$spec" ] && [ -f docs/11-paliers.md ]; then
  # Fonctionnalités : seules celles du MVP doivent figurer dans un palier.
  defined=$(grep -E '^### F-[0-9]+' "$spec" | grep -o -E 'F-[0-9]+' | sort -u)
  features=$(mvp_features "$spec")
  if [ -z "$defined" ]; then
    fail "aucune fonctionnalité au format « ### F-xx — Nom » dans $spec"
  else
    uncovered=""
    for id in $features; do
      grep -q -E "\b$id\b" docs/11-paliers.md || uncovered="$uncovered $id"
    done
    if [ -z "$uncovered" ]; then ok "fonctionnalités MVP ($(echo "$features" | grep -c .)) toutes rattachées à un palier"
    else fail "fonctionnalités MVP absentes de docs/11-paliers.md :$uncovered"; fi
    later=$(comm -23 <(echo "$defined") <(echo "$features") | tr '\n' ' ')
    [ -n "${later// /}" ] && info "fonctionnalités hors MVP, non exigées dans les paliers : $later"
  fi
  # Exigences non fonctionnelles : toutes doivent figurer dans un palier.
  enfs=$(grep -o -E '\bENF-[0-9]+\b' "$spec" | sort -u)
  if [ -z "$enfs" ]; then
    info "aucune exigence non fonctionnelle ENF-xx dans $spec"
  else
    uncovered=""
    for id in $enfs; do
      grep -q -E "\b$id\b" docs/11-paliers.md || uncovered="$uncovered $id"
    done
    if [ -z "$uncovered" ]; then ok "exigences non fonctionnelles ($(echo "$enfs" | grep -c .)) toutes rattachées à un palier"
    else fail "exigences non fonctionnelles absentes de docs/11-paliers.md :$uncovered"; fi
  fi
  # Identifiants cités dans les paliers mais définis nulle part.
  unknown=""
  for id in $(grep -o -E '\b(F|ENF)-[0-9]+\b' docs/11-paliers.md | sort -u); do
    case "$id" in
      F-*) echo "$defined" | grep -q -x "$id" || unknown="$unknown $id" ;;
      *)   echo "$enfs" | grep -q -x "$id" || unknown="$unknown $id" ;;
    esac
  done
  if [ -n "$unknown" ]; then fail "identifiants cités dans docs/11-paliers.md mais absents de $spec :$unknown"
  else ok "tous les identifiants cités dans les paliers existent dans la spécification"; fi
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
    for id in $(mvp_features docs/02-specifications-fonctionnelles.md); do
      grep -q -E "\b$id\b" docs/12-maquettes.md design/ecrans.js 2>/dev/null || nomock="$nomock $id"
    done
    [ -n "$nomock" ] && info "fonctionnalités MVP sans écran (normal si elles n'ont pas d'interface) :$nomock"
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
