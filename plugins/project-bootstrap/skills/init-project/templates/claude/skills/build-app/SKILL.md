---
name: build-app
description: Développe {{NOM_PROJET}} palier par palier selon docs/11-paliers.md, en validant chaque palier par des commandes exécutables avant de passer au suivant. À utiliser pour démarrer ou reprendre le développement, ou pour réaliser un palier précis.
---

# Développement par paliers — {{NOM_PROJET}}

Réglages du projet (définis au cadrage) :

- **Autonomie :** {{NIVEAU_AUTONOMIE}}
- **Tentatives de correction avant arrêt :** {{MAX_TENTATIVES}}
- **Branche principale :** `{{BRANCHE_PRINCIPALE}}`
- **Branches :** {{STRATEGIE_BRANCHES}} (voir section 3)
- **Commandes rapides après chaque tâche :** `{{CMD_LINT}}` puis `{{CMD_TEST_UNIT}}`

## 1. Démarrage de session

1. Lis `CLAUDE.md`, `PLAN.md` et `docs/11-paliers.md`.
2. Si la section « Blocages » de `PLAN.md` contient un blocage non résolu, présente-le et attends la réponse de l'utilisateur avant toute autre action.
3. Vérifie que le dossier est un dépôt git et que `git status` est propre. Sinon, présente les fichiers non commités et demande s'il faut les commiter (par exemple le cadrage initial) avant de commencer. Si le tag `tier-0` n'existe pas, crée-le sur le dernier commit de `{{BRANCHE_PRINCIPALE}}` (`git tag tier-0 {{BRANCHE_PRINCIPALE}}`).
4. Un palier dont le commit de clôture existe sans tag `tier-N` attend sa fusion (vérifie avec `git tag --list "tier-*"` et `git log --all --oneline -F --grep "chore(tier-N): palier validé"`, quelle que soit la branche courante). Termine-le selon la section 3 (« Reprise d'un palier en attente ») avant tout le reste.
5. Le palier courant est le premier palier non coché de `PLAN.md`. Si l'utilisateur demande un palier précis, vérifie que ses prérequis (« Dépend de ») sont cochés ; sinon signale-le et arrête-toi.
6. Lis uniquement les documents listés dans « Docs à lire » pour ce palier, plus les ADR qu'ils citent.
7. Place-toi sur la branche de travail du palier (section 3).

## 2. Boucle d'un palier

**a. Planifier.** Sous le palier dans `PLAN.md`, écris la liste des tâches : petites (une fonctionnalité, une migration, un endpoint, un écran), ordonnées, chacune avec le `F-xx`, `RG-xx` ou `ENF-xx` qu'elle sert. Commite `PLAN.md`.

**b. Réaliser chaque tâche en commençant par ses tests.** Pour chaque tâche, dans l'ordre :
1. Écris les tests qui traduisent ses critères d'acceptation et règles métier, cas limites compris, et vérifie qu'ils échouent. Ces tests matérialisent la spécification : tu ne les affaibliras plus ensuite, sauf si la spécification change avec l'accord de l'utilisateur.
2. Implémente jusqu'à ce qu'ils passent.
3. Lance les commandes rapides : tout doit être vert, tests des tâches précédentes compris.
4. Coche la tâche dans `PLAN.md` et commite au format Conventional Commits : `feat(tier-N): <résumé>` (ou `fix`, `test`, `refactor`, `chore`, `docs`).

Les tâches d'infrastructure sans comportement testable unitairement (outillage, Docker, CI) sont validées par une commande qui prouve qu'elles fonctionnent. Les exigences `ENF-xx` du palier sont vérifiées par la méthode prévue dans `docs/02-specifications-fonctionnelles.md` (commande, test de charge, mesure).

**c. Valider.** Lance **toutes** les commandes du bloc « Commandes de validation » du palier, dans l'ordre. Toutes doivent réussir (code de sortie 0).

**d. Corriger.** En cas d'échec, analyse la cause et corrige le code (jamais les tests ni la configuration des outils de qualité). Au-delà de {{MAX_TENTATIVES}} tentatives infructueuses sur le même échec :
- écris dans « Blocages » de `PLAN.md` : la commande, l'erreur, les hypothèses testées, la question à trancher ;
- commite ;
- arrête-toi et présente le blocage à l'utilisateur.

**e. Faire relire.** Lance le subagent `tier-reviewer` en lui donnant le numéro du palier. Corrige tous les points « bloquant » et « majeur », puis relance la validation (étape c). Les points « mineur » vont dans `PLAN.md` comme tâches pour plus tard.

**f. Clôturer.**
- Si l'implémentation s'écarte de la documentation, mets la documentation à jour ; si l'écart touche une décision, rédige un ADR et demande sa validation.
- Coche le palier dans `PLAN.md` et ajoute une ligne au journal.
- Commite `chore(tier-N): palier validé`.

**g. Point d'arrêt.** Arrête-toi et présente un compte rendu si le palier est marqué « Point d'arrêt humain : oui », ou si le niveau d'autonomie impose un arrêt après chaque palier. Avec la stratégie « pull request », c'est la pull request qui sert de point d'arrêt : passe directement à l'étape h.

Le compte rendu tient en quelques lignes : ce qui a été livré, la sortie résumée des validations, les écarts et ADR, les points mineurs reportés, le palier suivant. Si l'utilisateur demande des corrections, reprends à l'étape b sur la même branche, puis repasse par c à f.

**h. Terminer.** Avec le feu vert de l'utilisateur, ou directement s'il n'y avait pas de point d'arrêt, termine le palier selon la stratégie de branches (section 3) : la fusion et le tag `tier-N` marquent le palier comme terminé. Enchaîne ensuite sur le palier suivant si le niveau d'autonomie le permet.

## 3. Branches

Applique uniquement le cas qui correspond à la stratégie retenue au cadrage. Le tag `tier-N` est toujours posé sur `{{BRANCHE_PRINCIPALE}}` (ou sur la branche de développement unique) : c'est la référence dont `tier-reviewer` se sert pour comparer `tier-<N-1>..HEAD`.

**Une branche par palier, fusion locale par l'agent**
- *Branche de travail :* si `tier-N-<titre-court>` existe déjà (reprise en cours de palier), `git switch tier-N-<titre-court>` ; sinon `git switch {{BRANCHE_PRINCIPALE}}` puis `git switch -c tier-N-<titre-court>`.
- *Terminer :* `git switch {{BRANCHE_PRINCIPALE}}`, `git merge --no-ff tier-N-<titre-court> -m "merge: palier N — <titre>"`, `git tag tier-N`, puis `git branch -d tier-N-<titre-court>`.
- *Reprise d'un palier en attente :* demande le feu vert si le palier est un point d'arrêt, puis termine comme ci-dessus.
- En cas de conflit de fusion : `git merge --abort`, consigne le conflit dans « Blocages » et demande à l'utilisateur. Ne résous jamais un conflit en écartant les changements d'un côté.

**Une branche par palier, pull request fusionnée par l'utilisateur**
- *Branche de travail :* si `tier-N-<titre-court>` existe déjà, `git switch` dessus ; sinon `git switch {{BRANCHE_PRINCIPALE}}`, `git pull --ff-only`, puis `git switch -c tier-N-<titre-court>`.
- *Terminer :* `git push -u origin tier-N-<titre-court>`, puis ouvre la pull / merge request vers `{{BRANCHE_PRINCIPALE}}` avec la CLI de la forge si elle est installée (`gh pr create`, `glab mr create`, `tea pulls create`), sinon donne le lien de création à l'utilisateur. La description reprend le compte rendu de l'étape g. Arrête-toi : c'est l'utilisateur qui fusionne.
- *Reprise d'un palier en attente :* `git switch {{BRANCHE_PRINCIPALE}}` et `git pull --ff-only`. Si le palier y est coché dans `PLAN.md`, la pull request a été fusionnée : `git tag tier-N` sur ce commit, puis continue. Sinon, elle attend encore : signale-le et arrête-toi. Si l'utilisateur a demandé des changements sur la pull request, reviens sur la branche du palier et reprends à l'étape b.

**Branche de développement unique**
- *Branche de travail :* la branche indiquée dans la stratégie ; n'en crée aucune autre.
- *Terminer :* `git tag tier-N` sur le commit de clôture. Pas de fusion ni de push par l'agent.
- *Reprise d'un palier en attente :* demande le feu vert si le palier est un point d'arrêt, puis pose le tag.

## 4. Règles permanentes

- Ne modifie, ne supprime et n'ignore jamais un test pour faire passer une validation. Ne désactive jamais une règle de lint ou un avertissement.
- Ne passe jamais au palier suivant avec une validation en échec, ni avant que le palier courant ait son tag `tier-N`.
- N'invente aucune fonctionnalité absente de `docs/02-specifications-fonctionnelles.md`. Si un comportement n'est pas spécifié, arrête-toi, propose deux options et demande.
- Ne change ni la stack, ni une dépendance majeure, ni le modèle de données, ni l'architecture sans ADR validé par l'utilisateur.
- Pour toute tâche d'interface, ouvre la maquette de l'écran concerné (`docs/12-maquettes.md` → `design/ecrans/ecr-NN.html`) et reproduis sa structure, ses libellés et ses états. Le thème de l'application reprend les variables de `design/tokens.css`. Tout écart volontaire est noté dans `PLAN.md` et validé par l'utilisateur.
- Les migrations de base sont versionnées et passent par l'outil prévu dans `docs/05-modele-donnees.md`.
- Aucun secret dans le code ni dans les commits : uniquement des variables documentées dans `.env.example`. Si un nouveau fichier généré ou local apparaît dans `git status`, ajoute-le à `.gitignore` plutôt que de le commiter.
- Ne pousse jamais sur `{{BRANCHE_PRINCIPALE}}` et ne réécris jamais son historique ; seule la stratégie « pull request » autorise un push, celui de la branche du palier.
- N'agis jamais sur les environnements : {{ENVS_INTERDITS}}.

## 5. Gestion du contexte

À la fin de chaque palier, si la session est longue, propose à l'utilisateur de continuer dans une nouvelle session : `PLAN.md`, les tags `tier-N` et l'historique git suffisent pour reprendre exactement au même endroit.
