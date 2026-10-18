#!/usr/bin/env bash
# Lance tous les tests du dépôt : bash tests/run.sh. Code de sortie 0 = tout est vert.
# Les évaluations de comportement (claude plugin eval) sont à part : voir plugins/project-bootstrap/evals/README.md.

cd "$(dirname "$0")" || exit 2
status=0
for t in ./*.test.sh; do
  bash "$t" || status=1
  echo
done
if [ "$status" -eq 0 ]; then echo "Tous les tests sont verts."; else echo "Des tests échouent."; fi
exit "$status"
