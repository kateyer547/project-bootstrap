# Évaluations de project-bootstrap

Suite `claude plugin eval` qui mesure le comportement du plugin sur de vraies sessions Claude Code. Chaque exécution consomme des jetons sur ton compte : lance-la avant une nouvelle version, pas à chaque modification. Les contrôles rapides et gratuits sont dans `tests/` à la racine du dépôt (`bash tests/run.sh`).

Prérequis :

- le CLI Claude Code en version 2.1.269 ou plus (`claude --version`), et git 2.31 ou plus ;
- un CLI **connecté** : la connexion de l'application de bureau ne suffit pas. Lance une fois `claude` dans un terminal, tape `/login`, puis quitte. Sans cela, la suite s'arrête au premier cas avec « Not logged in ».

| Cas | Tag | Ce qui est vérifié |
|---|---|---|
| `cadrage-se-declenche` | `rapide` | Une demande de démarrage de projet déclenche `init-project`, qui ouvre l'entretien sans écrire de code |
| `hors-sujet-ne-declenche-pas` | `rapide` | Une question technique sans rapport ne déclenche pas `init-project` |
| `generation-express` | `lourd`, `api` | En mode Express, sans utilisateur, la documentation est générée : fichiers clés présents, paliers avec commandes, ENF, palier « Livraison » validé par `release-check`, guide `docs/14-deploiement.md`, `settings.json` qui interdit le déploiement, aucun marqueur restant, aucun code applicatif |
| `generation-express-interface` | `lourd`, `interface` | Même chose pour une application web : maquettes (`design/`, `docs/12`), critères « Étant donné », règles métier explicites |

## Lancer

Depuis la racine du dépôt, toujours avec le chemin du plugin et un tag :

```bash
claude plugin eval plugins/project-bootstrap --tag rapide --no-publish
```

Sans tag, la suite lance aussi le cas lourd sans lui accorder Write : ses graders ne peuvent pas passer, et la commande l'annonce par des avertissements « cannot pass with the granted tools ».

Les cas lourds écrivent des fichiers : il faut leur accorder Write et Edit. Il tourne une seule fois et sans comparaison sans plugin, qui n'aurait pas de sens pour une génération :

```bash
claude plugin eval plugins/project-bootstrap --tag lourd --ablation none --allow-tools Write Edit --no-publish --max-cost-usd 10
```

## Limites

- Les sessions d'évaluation ne sont pas interactives : personne ne répond aux questions de l'entretien. Les cas lourds demandent donc à Claude de retenir lui-même les options recommandées.
- Claude Code refuse les écritures dans `.claude/` pendant une évaluation (confirmation impossible). Les cas lourds demandent donc d'écrire ces fichiers dans `claude-config/`, avec la même arborescence, et les critères les vérifient à cet endroit. En utilisation réelle, ils vont bien dans `.claude/`.
- Le cas `generation-express-interface` est le plus coûteux (une centaine de tours, environ 7 $) et peut atteindre la limite d'utilisation de ta session. Pour lancer les cas lourds séparément : `--tag api` ou `--tag interface` à la place de `--tag lourd`.
- Bash n'est pas accordé : sous Windows natif, Claude Code ne peut pas isoler les commandes shell et refuse de les lancer. Le `git init`, le script de vérification et `spec-reviewer` ne sont donc pas exercés ici ; les tests de `tests/` couvrent le script. Pour les inclure, lance la suite sous WSL2 ou Linux avec `--allow-tools Write Edit Bash`.
- Les résultats sont écrits dans `evals/results/` du plugin (ou de la racine si la commande est lancée sans chemin), ignorés par git.
- Sous Windows, quand un cas échoue, Claude Code conserve son dossier temporaire `claude-eval-…` sans pouvoir le verrouiller : supprime-le avec la commande qu'il affiche, sans y lancer git ni aucun outil.
