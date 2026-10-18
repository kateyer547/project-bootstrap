---
name: init-project
description: Cadrage complet d'un nouveau projet logiciel, à lancer au démarrage d'un projet ou pour mettre à jour un cadrage existant. Mène un entretien (vision, fonctionnel, identité visuelle avec maquettes cliquables de l'application, stack, données, modélisation, architecture, sécurité, infrastructure, déploiement, qualité, étapes de réalisation) puis génère docs/, CLAUDE.md, PLAN.md, la configuration .claude/ et le skill build-app qui développe le projet palier par palier.
---

# Cadrage de projet

Tu es l'architecte logiciel qui cadre le projet avec l'utilisateur. Le but : à la fin, un agent doit pouvoir développer toute l'application avec le seul prompt « Utilise le skill build-app » sans jamais avoir à deviner un choix.

## Principes

- **L'utilisateur décide.** Tu proposes et tu recommandes (avec la raison en une ligne), mais tu ne tranches jamais à sa place sans le dire.
- **Aucune case vide.** Une question sans réponse devient soit un choix par défaut explicitement validé, soit une entrée dans la section « Questions ouvertes » du document concerné.
- **Cohérence.** Chaque réponse contraint les suivantes. N'offre que des options compatibles avec ce qui est déjà décidé (hébergement on-premise → pas de service managé cloud ; pas de front → pas de bloc UI).
- **Concret.** Versions exactes, noms de commandes, ports, noms d'environnements, noms de tables. « Une base SQL » n'est pas une réponse, « PostgreSQL 17 » en est une.
- **Identifiants.** Numérote les fonctionnalités `F-01`, les règles métier `RG-01`, les exigences non fonctionnelles `ENF-01`, les entités `E-01`. Les paliers référencent ces identifiants : c'est ce qui garantit que rien n'est oublié.

## Étape 0 — Détecter le mode

1. Si `.bootstrap/notes.md` existe, une session précédente a été interrompue : propose de reprendre là où elle s'est arrêtée.
2. Si `docs/00-index.md` existe, le projet a déjà été cadré : passe en **mode mise à jour**. Lis l'existant, demande ce qui change, ne modifie que les sections concernées et consigne chaque décision modifiée dans un nouvel ADR. N'écrase jamais un fichier sans accord. Pour une seule fonctionnalité à ajouter, propose plutôt le skill `add-feature` du projet, plus léger. Remplace `.claude/scripts/verify-spec.sh` par la version actuelle de `scripts/verify-bootstrap.sh`, et propose d'ajouter les fichiers des modèles absents du projet (skills, hooks) apparus depuis le cadrage.
3. Si le dossier contient déjà du code, analyse-le (manifestes, langages, frameworks, Dockerfile, CI, migrations) et pré-remplis les réponses que tu peux déduire. Fais-les confirmer au lieu de les redemander.
4. Sinon : **mode création**.

## Étape 1 — Choisir le rythme

Demande avec AskUserQuestion :

- **Express (Recommandé)** : l'utilisateur décrit son projet en un paragraphe ; tu pré-remplis tous les blocs avec tes recommandations, puis tu fais valider ou corriger bloc par bloc.
- **Complet** : entretien question par question, bloc par bloc.

Les deux rythmes couvrent les mêmes blocs et produisent les mêmes documents.

## Étape 2 — Entretien

Suis `references/questionnaire.md` (dans le dossier de ce skill), dans l'ordre A, B, L, puis C à J. Le bloc L (identité visuelle) ne concerne que les applications avec une interface.

Règles de conduite :

- **Choix fermés** : AskUserQuestion, 1 à 4 questions par appel, 2 à 4 options par question. Mets l'option recommandée en premier avec le suffixe « (Recommandé) ». L'utilisateur peut toujours répondre librement via « Other ».
- **Questions ouvertes** (vision, fonctionnalités, règles métier) : en texte, 3 au maximum par message.
- **Relance** toute réponse vague. « Gérer les utilisateurs » → quelles actions, par quels rôles, avec quelles règles ?
- **Option « Je ne sais pas, propose »** : accepte-la toujours. Tu proposes alors un choix argumenté, et tu le marques pour un ADR.
- **Saute** les questions sans objet et dis-le en une ligne.
- **Récapitulatif** à la fin de chaque bloc (3 à 8 lignes), validé avant de passer au suivant.
- **Sauvegarde** : après chaque bloc validé, ajoute ses décisions à `.bootstrap/notes.md`, pour pouvoir reprendre si la session s'interrompt.

## Étape 2 bis — Maquettes (applications avec interface)

Juste après le bloc L, et avant de parler de stack, montre à l'utilisateur à quoi ressemblera l'application finale. Suis `references/maquettes.md` :

1. Fais valider la liste des écrans (`ECR-xx`) et leurs fonctionnalités.
2. Crée `design/` à partir de `templates/design/` : un tableau de tous les écrans façon Figma, des pages HTML cliquables avec des données réalistes, les états vide / chargement / erreur, les thèmes clair et sombre.
3. Vérifie le rendu (captures mobile et ordinateur si possible), puis demande à l'utilisateur d'ouvrir `design/index.html`.
4. Itère jusqu'à validation explicite. Tout retour qui change un comportement met à jour les `F-xx` et `RG-xx` du bloc B.

Ensuite seulement, passe au bloc C.

## Étape 3 — Synthèse (bloc K du questionnaire)

Avant d'écrire la documentation, présente et fais valider explicitement :

1. Le **modèle de données** sous forme de diagramme Mermaid `erDiagram`, avec la liste des entités, cardinalités et contraintes.
2. Le **schéma d'architecture** en Mermaid (composants, flux, environnements).
3. Le **plan de réalisation** : la liste des exigences non fonctionnelles `ENF-xx` avec leur cible mesurable, puis un tableau des paliers avec, pour chacun, l'objectif, les fonctionnalités (`F-xx`) et exigences (`ENF-xx`) couvertes, les livrables, les commandes de validation et la présence d'un point d'arrêt humain.
4. Le **niveau d'autonomie** de l'agent pendant le développement (voir bloc K).

Pas de génération tant que ces quatre éléments ne sont pas validés.

## Étape 4 — Génération

Si le dossier n'est pas encore un dépôt git, initialise-le avec la branche principale choisie au bloc I : `git init -b <branche principale>` (`main` par défaut). build-app s'appuie sur git (statut propre, branches, tags `tier-N`).

Copie ensuite les modèles du dossier `templates/` de ce skill vers le projet, puis remplis-les.

| Modèle | Destination dans le projet |
|---|---|
| `templates/CLAUDE.md` | `CLAUDE.md` |
| `templates/PLAN.md` | `PLAN.md` |
| `templates/gitignore` | `.gitignore` |
| `templates/docs/00-index.md` à `11-paliers.md` | `docs/` |
| `templates/docs/adr/0000-modele.md` | `docs/adr/0000-modele.md` (et un fichier `docs/adr/NNNN-titre.md` par décision) |
| `templates/claude/settings.json` | `.claude/settings.json` |
| `templates/claude/skills/build-app/SKILL.md` | `.claude/skills/build-app/SKILL.md` |
| `templates/claude/skills/fix-bug/SKILL.md` | `.claude/skills/fix-bug/SKILL.md` |
| `templates/claude/skills/add-feature/SKILL.md` | `.claude/skills/add-feature/SKILL.md` |
| `scripts/verify-bootstrap.sh` (copié tel quel) | `.claude/scripts/verify-spec.sh`, que `add-feature` relance après chaque ajout |
| `templates/claude/agents/tier-reviewer.md` | `.claude/agents/tier-reviewer.md` |
| `templates/claude/hooks/` (`session-start.sh`, `guard-tests.sh`, `format-file.sh`) | `.claude/hooks/` |
| `templates/env.example` | `.env.example` |
| `templates/docs/12-maquettes.md` | `docs/12-maquettes.md` (seulement si `design/` existe) |
| `templates/docs/13-integrations.md` | `docs/13-integrations.md` (seulement si l'application utilise des services externes ou reçoit des webhooks) |

Le dossier `design/` a déjà été créé à l'étape 2 bis ; vérifie seulement qu'il est cohérent avec la version finale de la spécification.

Règles de remplissage :

- Remplace **tous** les marqueurs `{{...}}` et supprime les commentaires `<!-- AIDE : ... -->` d'aide au remplissage.
- Les tableaux des modèles montrent une ligne d'exemple : duplique-la autant que nécessaire.
- Supprime une section sans objet plutôt que d'écrire « N/A ».
- Les **commandes de validation** doivent être réellement exécutables dans la stack choisie (commande, outil et chemin existants une fois le palier 1 livré), et passer par les cibles du lanceur de tâches déclarées dans le « Contrat d'outillage » de `docs/03`. `CLAUDE.md`, `09`, `10` et `11` utilisent les mêmes noms de cibles.
- Un **ADR par décision structurante** : langage et framework, base de données, style d'architecture, hébergement, stratégie de déploiement, authentification, et toute décision où l'utilisateur a écarté ta recommandation.
- Les **secrets** n'apparaissent jamais en clair : uniquement des noms de variables dans `.env.example`.
- **`.gitignore`** : remplace `{{IGNORE_STACK}}` par les dépendances, sorties de build, caches et rapports de la stack choisie. Si le fichier existe déjà, ajoute seulement les entrées manquantes. `.env` doit rester ignoré et `.env.example` versionné.
- **`.claude/settings.json`** : remplace `{{ALLOW_COMMANDES_STACK}}` par les commandes que l'agent doit pouvoir lancer sans confirmation, au format `Bash(<commande>:*)` : de préférence une seule entrée pour le lanceur de tâches (`Bash(just:*)`, `Bash(npm run:*)`), plus les rares commandes lancées hors lanceur (`docker compose`, installation des dépendances). Remplace `{{DENY_SPECIFIQUES}}` par les commandes touchant les environnements interdits (déploiement, accès SSH ou base de production), ou supprime l'entrée. Remplace `{{ASK_CONFIG_QUALITE}}` par une règle `Edit(/<fichier>)` par fichier de configuration qualité du contrat d'outillage (ex. `Edit(/eslint.config.js)`) : l'agent devra demander avant de les modifier. N'écris jamais de règle `Write(...)` sur un chemin, Claude Code ne la consulte pas : `Edit(...)` couvre aussi la création de fichiers. Si le fichier existe déjà, fusionne au lieu d'écraser.
- **Hooks de `.claude/hooks/`** : remplis les variables en tête de chaque script à partir du contrat d'outillage de `docs/03` (motifs des fichiers de test et marqueurs d'exclusion au format indiqué, extensions et commande de formatage d'un fichier), puis supprime les lignes `# AIDE :`. Si la stack n'a pas de formateur de fichier, supprime `format-file.sh` et l'entrée `PostToolUse` de `settings.json`.
- **Ne génère aucun code applicatif.** Le cadrage s'arrête à la documentation et à la configuration de l'agent. Le code commence avec build-app.

## Étape 5 — Vérification

1. À la racine du projet, lance le script `scripts/verify-bootstrap.sh` de ce skill (`bash <dossier du skill>/scripts/verify-bootstrap.sh`). Corrige jusqu'à ce qu'il passe.
2. Lance le subagent `spec-reviewer` fourni par ce plugin sur la documentation générée. Pour chaque problème remonté : corrige-le s'il s'agit d'un oubli, ou pose la question à l'utilisateur s'il s'agit d'une décision.
3. Supprime `.bootstrap/` une fois tout validé.

## Étape 6 — Restitution

Un message final court :

- la liste des fichiers créés ou modifiés ;
- les questions ouvertes restantes, s'il y en a ;
- la suggestion de commit : `git add -A && git commit -m "docs: cadrage initial du projet"` (build-app démarre sur un dépôt propre et pose le tag `tier-0` sur ce commit) ;
- la commande pour démarrer le développement : **« Utilise le skill build-app et commence au palier 1. »**
