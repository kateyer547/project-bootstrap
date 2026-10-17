---
name: build-app
description: Développe {{NOM_PROJET}} palier par palier selon docs/11-paliers.md, en validant chaque palier par des commandes exécutables avant de passer au suivant. À utiliser pour démarrer ou reprendre le développement, ou pour réaliser un palier précis.
---

# Développement par paliers — {{NOM_PROJET}}

Réglages du projet (définis au cadrage) :

- **Autonomie :** {{NIVEAU_AUTONOMIE}}
- **Tentatives de correction avant arrêt :** {{MAX_TENTATIVES}}
- **Branches :** {{STRATEGIE_BRANCHES}}
- **Commandes rapides après chaque tâche :** `{{CMD_LINT}}` puis `{{CMD_TEST_UNIT}}`

## 1. Démarrage de session

1. Lis `CLAUDE.md`, `PLAN.md` et `docs/11-paliers.md`.
2. Si la section « Blocages » de `PLAN.md` contient un blocage non résolu, présente-le et attends la réponse de l'utilisateur avant toute autre action.
3. Le palier courant est le premier palier non coché de `PLAN.md`. Si l'utilisateur demande un palier précis, vérifie que ses prérequis (« Dépend de ») sont cochés ; sinon signale-le et arrête-toi.
4. Lis uniquement les documents listés dans « Docs à lire » pour ce palier, plus les ADR qu'ils citent.
5. Vérifie que `git status` est propre. Si le tag `tier-0` n'existe pas, crée-le sur le commit courant (`git tag tier-0`).
6. Selon la stratégie de branches, crée la branche du palier : `tier-N-<titre-court>`.

## 2. Boucle d'un palier

**a. Planifier.** Sous le palier dans `PLAN.md`, écris la liste des tâches : petites (une fonctionnalité, une migration, un endpoint, un écran), ordonnées, chacune avec le `F-xx` ou `RG-xx` qu'elle sert. Commite `PLAN.md`.

**b. Réaliser chaque tâche en commençant par ses tests.** Pour chaque tâche, dans l'ordre :
1. Écris les tests qui traduisent ses critères d'acceptation et règles métier, cas limites compris, et vérifie qu'ils échouent. Ces tests matérialisent la spécification : tu ne les affaibliras plus ensuite, sauf si la spécification change avec l'accord de l'utilisateur.
2. Implémente jusqu'à ce qu'ils passent.
3. Lance les commandes rapides : tout doit être vert, tests des tâches précédentes compris.
4. Coche la tâche dans `PLAN.md` et commite au format Conventional Commits : `feat(tier-N): <résumé>` (ou `fix`, `test`, `refactor`, `chore`, `docs`).

Les tâches d'infrastructure sans comportement testable unitairement (outillage, Docker, CI) sont validées par une commande qui prouve qu'elles fonctionnent.

**c. Valider.** Lance **toutes** les commandes du bloc « Commandes de validation » du palier, dans l'ordre. Toutes doivent réussir (code de sortie 0).

**d. Corriger.** En cas d'échec, analyse la cause et corrige le code (jamais les tests ni la configuration des outils de qualité). Au-delà de {{MAX_TENTATIVES}} tentatives infructueuses sur le même échec :
- écris dans « Blocages » de `PLAN.md` : la commande, l'erreur, les hypothèses testées, la question à trancher ;
- commite ;
- arrête-toi et présente le blocage à l'utilisateur.

**e. Faire relire.** Lance le subagent `tier-reviewer` en lui donnant le numéro du palier. Corrige tous les points « bloquant » et « majeur », puis relance la validation (étape c). Les points « mineur » vont dans `PLAN.md` comme tâches pour plus tard.

**f. Clôturer.**
- Si l'implémentation s'écarte de la documentation, mets la documentation à jour ; si l'écart touche une décision, rédige un ADR et demande sa validation.
- Coche le palier dans `PLAN.md` et ajoute une ligne au journal.
- Commite `chore(tier-N): palier validé`, puis pose le tag `tier-N`.

**g. Point d'arrêt.** Arrête-toi et présente un compte rendu si :
- le palier est marqué « Point d'arrêt humain : oui » ;
- ou le niveau d'autonomie impose un arrêt après chaque palier.

Le compte rendu tient en quelques lignes : ce qui a été livré, la sortie résumée des validations, les écarts et ADR, les points mineurs reportés, le palier suivant. Sinon, enchaîne sur le palier suivant.

## 3. Règles permanentes

- Ne modifie, ne supprime et n'ignore jamais un test pour faire passer une validation. Ne désactive jamais une règle de lint ou un avertissement.
- Ne passe jamais au palier suivant avec une validation en échec.
- N'invente aucune fonctionnalité absente de `docs/02-specifications-fonctionnelles.md`. Si un comportement n'est pas spécifié, arrête-toi, propose deux options et demande.
- Ne change ni la stack, ni une dépendance majeure, ni le modèle de données, ni l'architecture sans ADR validé par l'utilisateur.
- Pour toute tâche d'interface, ouvre la maquette de l'écran concerné (`docs/12-maquettes.md` → `design/ecrans/ecr-NN.html`) et reproduis sa structure, ses libellés et ses états. Le thème de l'application reprend les variables de `design/tokens.css`. Tout écart volontaire est noté dans `PLAN.md` et validé par l'utilisateur.
- Les migrations de base sont versionnées et passent par l'outil prévu dans `docs/05-modele-donnees.md`.
- Aucun secret dans le code ni dans les commits : uniquement des variables documentées dans `.env.example`.
- N'agis jamais sur les environnements : {{ENVS_INTERDITS}}.

## 4. Gestion du contexte

À la fin de chaque palier, si la session est longue, propose à l'utilisateur de continuer dans une nouvelle session : `PLAN.md`, les tags `tier-N` et l'historique git suffisent pour reprendre exactement au même endroit.
