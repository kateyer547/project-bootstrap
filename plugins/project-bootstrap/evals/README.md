# Évaluations de project-bootstrap

Suite `claude plugin eval` qui mesure le comportement du plugin sur de vraies sessions Claude Code. Chaque exécution consomme des jetons sur ton compte : lance-la avant une nouvelle version, pas à chaque modification. Les contrôles rapides et gratuits sont dans `tests/` à la racine du dépôt (`bash tests/run.sh`).

Prérequis : le CLI Claude Code en version 2.1.269 ou plus (`claude --version`), et git 2.31 ou plus.

| Cas | Tag | Ce qui est vérifié |
|---|---|---|
| `cadrage-se-declenche` | `rapide` | Une demande de démarrage de projet déclenche `init-project`, qui ouvre l'entretien sans écrire de code |
| `hors-sujet-ne-declenche-pas` | `rapide` | Une question technique sans rapport ne déclenche pas `init-project` |
| `generation-express` | `lourd` | En mode Express, sans utilisateur, la documentation est générée : fichiers clés présents, paliers avec commandes, ENF, aucun marqueur restant, aucun code applicatif |

## Lancer

Depuis la racine du dépôt :

```bash
claude plugin eval plugins/project-bootstrap --tag rapide --no-publish
```

Le cas lourd écrit des fichiers : il faut lui accorder Write et Edit. Il tourne une seule fois et sans comparaison sans plugin, qui n'aurait pas de sens pour une génération :

```bash
claude plugin eval plugins/project-bootstrap --tag lourd --ablation none --allow-tools Write Edit --no-publish --max-cost-usd 10
```

## Limites

- Les sessions d'évaluation ne sont pas interactives : personne ne répond aux questions de l'entretien. Le cas lourd demande donc à Claude de retenir lui-même les options recommandées.
- Bash n'est pas accordé : sous Windows natif, Claude Code ne peut pas isoler les commandes shell et refuse de les lancer. Le `git init`, le script de vérification et `spec-reviewer` ne sont donc pas exercés ici ; les tests de `tests/` couvrent le script. Pour les inclure, lance la suite sous WSL2 ou Linux avec `--allow-tools Write Edit Bash`.
- Les résultats sont écrits dans `evals/results/`, ignoré par git.
