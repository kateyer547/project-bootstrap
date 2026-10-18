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
| B. Fonctionnel | fonctionnalités `F-xx`, règles métier `RG-xx`, rôles, interface, hors périmètre |
| C. Stack | backend, accès aux données, front, mobile, services annexes, outillage, versions |
| D. Données | sources, volumétrie, seed, données personnelles, cycle de vie, sauvegardes |
| E. Modélisation | SGBD, entités, relations, conventions, index, migrations (diagramme `erDiagram`) |
| F. Architecture | style, couches, API, erreurs, configuration, observabilité |
| G. Sécurité | authentification, autorisation, protections, secrets, audit |
| H. Infrastructure | hébergement, environnements, réseau, conteneurs, IaC, supervision |
| I. Déploiement | forge, branches, pipeline, stratégie de mise en production, retour arrière |
| J. Qualité | niveaux de tests, couverture, lint, revue, Definition of Done |
| K. Paliers | exigences non fonctionnelles `ENF-xx` chiffrées, découpage, commandes de validation, points d'arrêt, autonomie de l'agent, stratégie de branches |
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
  12-maquettes.md                  écrans, parcours, identité visuelle
  adr/                             une décision structurante par fichier
design/                            maquettes cliquables (index.html = tableau des écrans)
.claude/
  settings.json                    permissions et hook de formatage
  skills/build-app/SKILL.md        le développement par paliers
  agents/tier-reviewer.md          relecteur indépendant de chaque palier
```

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
3. implémente et commite tâche par tâche ;
4. lance toutes les commandes de validation du palier ;
5. corrige, avec un nombre limité de tentatives avant de s'arrêter et d'expliquer le blocage ;
6. fait relire par `tier-reviewer` ;
7. met à jour la doc et coche le palier ;
8. s'arrête pour ton feu vert, ou enchaîne selon le niveau d'autonomie choisi ;
9. fusionne la branche du palier dans la branche principale (ou ouvre une pull request que tu fusionnes, selon la stratégie choisie) et pose le tag `tier-N`.

Une nouvelle session reprend exactement là où la précédente s'est arrêtée, grâce à `PLAN.md` et aux tags.

## Mettre à jour un cadrage

Relance `/project-bootstrap:init-project` dans un projet déjà cadré : Claude passe en mode mise à jour, ne modifie que ce qui change et consigne chaque décision modifiée dans un ADR.

## Personnaliser

- Questions : `skills/init-project/references/questionnaire.md`
- Modèles de documents et de maquettes : `skills/init-project/templates/`
- Guide des maquettes : `skills/init-project/references/maquettes.md`
- Contrôles automatiques : `skills/init-project/scripts/verify-bootstrap.sh`
- Relecture de la spec : `agents/spec-reviewer.md`

## Conseils

- Lance le développement dans un environnement isolé (conteneur, VM ou ton serveur d'agents) si tu choisis l'autonomie complète.
- Garde des points d'arrêt humains au moins après le socle, après le modèle de données et avant le déploiement.
- Quand l'agent se trompe de façon récurrente, corrige le `CLAUDE.md` ou les tests plutôt que de répéter la consigne.
