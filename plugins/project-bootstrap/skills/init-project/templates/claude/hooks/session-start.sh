#!/usr/bin/env bash
# Hook SessionStart de {{NOM_PROJET}} : rappelle à Claude l'état du projet à chaque ouverture,
# reprise ou compaction de session, même quand build-app n'est pas invoqué.
# Ce que le script affiche est ajouté au contexte de la session.

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
[ -f PLAN.md ] || exit 0

courant=$(grep -m 1 -E '^- \[ \] \*\*Palier' PLAN.md | sed -E 's/^- \[ \] \*\*([^*]*)\*\*(.*)$/\1\2/' | tr -d '\r')
[ -n "$courant" ] || courant="aucun : tous les paliers de PLAN.md sont cochés"

blocages=$(awk '
  { sub(/\r$/, "") }
  /^## Blocages/ { dans = 1; next }
  /^## / { dans = 0 }
  dans && /<!--/ { commentaire = 1 }
  dans && !commentaire && NF { n++ }
  dans && /-->/ { commentaire = 0 }
  END { print n + 0 }
' PLAN.md)

echo "État du projet (hook session-start) :"
echo "- Palier courant : $courant"
if [ "$blocages" -gt 0 ]; then
  echo "- BLOCAGE ouvert dans PLAN.md (section « Blocages ») : présente-le à l'utilisateur et attends sa réponse avant toute autre action."
else
  echo "- Aucun blocage ouvert."
fi

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  attente=""
  for n in $(git log --all --format=%s 2>/dev/null | sed -n -E 's/^chore\(tier-([0-9]+)\): palier validé.*/\1/p' | sort -un); do
    git rev-parse -q --verify "refs/tags/tier-$n" >/dev/null || attente="$attente $n"
  done
  [ -n "$attente" ] && echo "- Palier(s) validé(s) en attente de fusion :$attente (voir build-app, section 3)."
  branche=$(git branch --show-current 2>/dev/null)
  tag=$(git describe --tags --abbrev=0 --match 'tier-*' 2>/dev/null || echo "aucun")
  modifies=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  echo "- Branche : ${branche:-détachée} ; dernier tag de palier : $tag ; fichiers non commités : $modifies"
fi
echo "- Skills du projet : build-app (paliers), fix-bug (bug signalé), add-feature (fonctionnalité absente de docs/02). Lis CLAUDE.md avant de modifier le code."
exit 0
