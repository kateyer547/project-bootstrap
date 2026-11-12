#!/usr/bin/env bash
# Autopilote de {{NOM_PROJET}} : enchaîne des sessions Claude Code non interactives,
# un palier par session (skill build-app, section 8), jusqu'à ce que tous les paliers
# de PLAN.md soient cochés ou qu'une intervention humaine soit nécessaire : blocage,
# point d'arrêt, livraison à relire, pull request à fusionner.
#
# Usage : bash .claude/scripts/autopilote.sh [nombre maximal de sessions, 20 par défaut]
#
# À lancer dans un environnement isolé (conteneur, VM) : l'agent y travaille sans
# surveillance. Les modifications de fichiers sont acceptées automatiquement ; les
# commandes non autorisées par .claude/settings.json et les règles « ask » sont refusées,
# et l'agent les consigne comme blocage. Journaux des sessions : .autopilote/
# Variable CLAUDE_BIN : commande claude à utiliser (par défaut « claude »).

set -u
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 2

MAX=${1:-20}
CLAUDE=${CLAUDE_BIN:-claude}
LOGS=.autopilote
PROMPT="Utilise le skill build-app en mode autopilote (section 8) : réalise le palier courant, puis termine la session."

[ -f PLAN.md ] || { echo "PLAN.md introuvable : lance d'abord le cadrage."; exit 2; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Ce dossier n'est pas un dépôt git."; exit 2; }
command -v "$CLAUDE" >/dev/null 2>&1 || { echo "Commande introuvable : $CLAUDE"; exit 2; }
mkdir -p "$LOGS"

# Nombre de lignes non vides hors commentaires dans une section « ## <titre> » de PLAN.md.
section_count() {
  awk -v titre="$1" '
    { sub(/\r$/, "") }
    index($0, "## " titre) == 1 { dans = 1; next }
    /^## / { dans = 0 }
    dans && /<!--/ { commentaire = 1 }
    dans && !commentaire && NF { n++ }
    dans && /-->/ { commentaire = 0 }
    END { print n + 0 }
  ' PLAN.md
}

remaining() { grep -c -E '^- \[ \] \*\*Palier' PLAN.md || true; }
current() { grep -m 1 -E '^- \[ \] \*\*Palier' PLAN.md | sed -E 's/^- \[ \] \*\*([^*]*)\*\*.*$/\1/' | tr -d '\r'; }

# Paliers validés (commit de clôture) sans tag tier-N : point d'arrêt ou fusion en attente.
waiting() {
  local n out=""
  for n in $(git log --all --format=%s 2>/dev/null | sed -n -E 's/^chore\(tier-([0-9]+)\): palier validé.*/\1/p' | sort -un); do
    git rev-parse -q --verify "refs/tags/tier-$n" >/dev/null || out="$out $n"
  done
  echo "$out"
}

for i in $(seq 1 "$MAX"); do
  if [ "$(section_count Blocages)" -gt 0 ]; then
    echo "Arrêt : blocage ouvert dans PLAN.md (section « Blocages »). Réponds-y, puis relance le script."
    exit 1
  fi
  w=$(waiting)
  if [ -n "$w" ]; then
    echo "Arrêt : palier(s)$w validé(s), en attente de ton feu vert ou de la fusion de la pull request."
    echo "Relis le compte rendu (et la livraison le cas échéant), puis dis à Claude : « Utilise le skill build-app et termine le palier »."
    exit 0
  fi
  if [ "$(remaining)" -eq 0 ]; then
    echo "Terminé : tous les paliers de PLAN.md sont cochés. Guide de déploiement : docs/14-deploiement.md."
    exit 0
  fi
  decisions=$(section_count "Décisions à confirmer")
  avant=$(git rev-parse HEAD 2>/dev/null || echo aucun)
  log="$LOGS/session-$(date +%Y%m%d-%H%M%S)-$i.log"
  echo "Session $i/$MAX : $(current) (journal : $log ; décisions à confirmer : $decisions)"
  "$CLAUDE" -p "$PROMPT" --permission-mode acceptEdits > "$log" 2>&1
  code=$?
  tail -n 15 "$log" | sed 's/^/  | /'
  if [ "$code" -ne 0 ]; then
    echo "Arrêt : la session s'est terminée en erreur (code $code), voir $log."
    exit 1
  fi
  if [ "$(git rev-parse HEAD 2>/dev/null || echo aucun)" = "$avant" ]; then
    echo "Arrêt : la session n'a produit aucun commit, voir $log."
    exit 1
  fi
done
echo "Arrêt : $MAX sessions atteintes. Relance le script pour continuer."
