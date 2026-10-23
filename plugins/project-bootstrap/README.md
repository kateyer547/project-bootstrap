# project-bootstrap

Transforme une idée de projet en un dépôt prêt à être développé par un agent, palier par palier, avec une validation automatisée à chaque étape.

## Installation

```
/plugin marketplace add <url-git-du-depot>
/plugin install project-bootstrap@kateyer-plugins
```

## Ce que fait le plugin

**1. Entretien de cadrage** (`/project-bootstrap:init-project`)

Deux rythmes au choix :
- **Express** : tu décris ton projet en un paragraphe, Claude pré-remplit tout et tu valides ou corriges bloc par bloc.
- **Complet** : question par question.

Blocs couverts :

| Bloc | Sujets |
|---|---|
| A. Vision | problème, utilisateurs, critères de réussite, échéances, contraintes |
| B. Fonctionnel | fonctionnalités `F-xx`, règles métier `RG-xx`, rôles, interface, hors périmètre, navigateurs, langues et formats |
| C. Stack | backend, accès aux données, front, mobile, services annexes, outillage, versions, lanceur de tâches et **contrat d'outillage** (commandes en mode vérification, formatage d'un fichier, marqueurs de tests) |
| D. Données | sources, volumétrie, seed, données personnelles, cycle de vie, sauvegardes, reprise de données existantes |
| E. Modélisation | SGBD, entités, relations, conventions, index, migrations (diagramme `erDiagram`) |
| F. Architecture | style, couches, API, erreurs, configuration, observabilité, architecture front, intégrations externes (`13-integrations.md`) |
| G. Sécurité | authentification, autorisation, protections, secrets, audit |
| K. Paliers | exigences non fonctionnelles `ENF-xx` chiffrées, découpage, commandes de validation, points d'arrêt, autonomie de l'agent, branche principale et stratégie de branches |
| L. Identité visuelle | ambiance, couleurs, police, thèmes, navigation, références, puis **maquettes cliquables** |

**Maquettes de l'application** (si elle a une interface) : juste après le fonctionnel, Claude construit dans `design/` un prototype cliquable façon Figma. `design/index.html` affiche tous les écrans côte à côte, en mobile ou ordinateur, en clair ou sombre, avec les fonctionnalités annotées ; chaque écran s'ouvre en plein écran avec ses états (normal, vide, chargement, erreur) et ses liens vers les écrans suivants. Tu itères jusqu'à ce que le rendu te plaise, et la spec est mise à jour en même temps. Un exemple complet est dans `skills/init-project/examples/maquettes-canettes/`.

Avant d'écrire, Claude te fait valider le modèle de données, le schéma d'architecture et le plan des paliers.

**2. Génération dans ton projet**

```
CLAUDE.md                          mémoire du projet (stack, commandes, règles)
PLAN.md                            avancement partagé entre les sessions
.env.example                       variables d'environnement
.gitignore                         secrets, sorties de build et caches de la stack
docs/
  00-index.md … 11-paliers.md      la spécification complète
  12-maquettes.md                  écrans, parcours, identité visuelle (si interface)
  13-integrations.md               services externes, bouchons de test, pannes (si besoin)
  adr/                             une décision structurante par fichier
design/                            maquettes cliquables (index.html = tableau des écrans)
.claude/
  settings.json                    permissions (allow, ask, deny) et déclaration des hooks
  hooks/                           garde-fous exécutés par Claude Code (voir ci-dessous)
  skills/build-app/SKILL.md        le développement par paliers
  skills/fix-bug/SKILL.md          la correction d'un bug, test qui le reproduit d'abord
  skills/add-feature/SKILL.md      l'ajout d'une fonctionnalité : spécification et palier avant le code
  agents/tier-reviewer.md          relecteur indépendant de chaque palier ou correctif
  scripts/verify-spec.sh           copie du script de vérification, relancée par add-feature
```

**Garde-fous réels**, appliqués par Claude Code à chaque action et pas seulement écrits dans les consignes :

| Garde-fou | Effet |
|---|---|
| `hooks/guard-tests.sh` | refuse l'ajout de `skip`, `only`, `ignore`… dans un fichier de test |
| `hooks/session-start.sh` | à chaque ouverture de session, rappelle le palier courant, les blocages ouverts, un palier en attente de fusion, la branche et le dernier tag |
| `hooks/format-file.sh` | formate uniquement le fichier qui vient d'être modifié |
| règles `deny` | interdisent `--no-verify`, `push --force`, `reset --hard`, `branch -D` |
| règles `ask` | demandent ton accord avant toute modification de `.claude/`, de `.githooks/` ou des fichiers de configuration qualité |

Ce sont des filets, pas des barrières absolues : une commande shell écrite autrement peut passer à travers. `tier-reviewer` contrôle aussi ces contournements à chaque palier.

**3. Vérification**

- Un script contrôle que rien ne manque : fichiers présents, aucun champ non rempli, dépôt git initialisé avec `.env` ignoré, chaque palier a ses commandes de validation, chaque fonctionnalité MVP et chaque exigence non fonctionnelle est rattachée à un palier, aucun identifiant inconnu, aucun secret apparent. Il fonctionne avec Node, Python ou jq pour valider le JSON.
- Le subagent `spec-reviewer` relit l'ensemble comme le ferait l'agent développeur et signale les oublis, contradictions et ambiguïtés.

## Développement ensuite

```
Utilise le skill build-app et commence au palier 1.
```

Pour chaque palier, `build-app` :
1. découpe le palier en tâches dans `PLAN.md` ;
2. écrit les tests de chaque tâche avant le code ;
3. implémente, lance `check` (la même commande que la CI et le hook `pre-commit`) et commite tâche par tâche ; au palier 1, prouve que `check` échoue vraiment sur une erreur de format, de lint ou de test ;
4. lance toutes les commandes de validation du palier ;
5. corrige, avec un nombre limité de tentatives avant de s'arrêter et d'expliquer le blocage ;
6. fait relire par `tier-reviewer` ;
7. met à jour la doc et coche le palier ;
8. s'arrête pour ton feu vert, ou enchaîne selon le niveau d'autonomie choisi ;
9. fusionne la branche du palier dans la branche principale (ou ouvre une pull request que tu fusionnes, selon la stratégie choisie) et pose le tag `tier-N`.

Une nouvelle session reprend exactement là où la précédente s'est arrêtée, grâce à `PLAN.md`, aux tags et au hook `session-start.sh`.

## Bugs et nouvelles fonctionnalités

Pendant et après le MVP, deux skills gardent la même discipline :

- **« Il y a un bug… »** → `fix-bug` : il écrit d'abord un test qui reproduit le bug, cherche la cause, corrige, lance `check`, fait relire par `tier-reviewer` et note le correctif dans `PLAN.md`. Si le comportement attendu n'est pas spécifié, il te le fait trancher et ajoute la règle métier.
- **« Ajoute… »** → `add-feature` : il mène un entretien court, met à jour la spécification (`F-xx`, `RG-xx`, `ENF-xx`), le modèle, l'API et la maquette, ajoute un palier et relance la vérification. `build-app` réalise ensuite ce palier.

## Mettre à jour un cadrage

Relance `/project-bootstrap:init-project` dans un projet déjà cadré : Claude passe en mode mise à jour, ne modifie que ce qui change et consigne chaque décision modifiée dans un ADR.

## Personnaliser

- Questions : `skills/init-project/references/questionnaire.md`
- Modèles de documents et de maquettes : `skills/init-project/templates/`
- Guide des maquettes : `skills/init-project/references/maquettes.md`
- Contrôles automatiques : `skills/init-project/scripts/verify-bootstrap.sh`
- Relecture de la spec : `agents/spec-reviewer.md`

`index.html`, `proto.js` et `components.css` existent en deux exemplaires identiques : dans `templates/design/` et dans l'exemple `examples/maquettes-canettes/`, qui doit rester ouvrable seul. Après une modification du modèle, recopie-les dans l'exemple ; `bash tests/run.sh` échoue tant que les copies diffèrent.

## Tester le plugin

- `bash tests/run.sh` (racine du dépôt) : tests automatiques du script de vérification et des modèles.
- `evals/` : évaluations `claude plugin eval` du comportement réel, voir [evals/README.md](evals/README.md).

## Conseils

- Lance le développement dans un environnement isolé (conteneur, VM ou ton serveur d'agents) si tu choisis l'autonomie complète.
- Garde des points d'arrêt humains au moins après le socle, après le modèle de données et avant le déploiement.
- Quand l'agent se trompe de façon récurrente, corrige le `CLAUDE.md` ou les tests plutôt que de répéter la consigne.
