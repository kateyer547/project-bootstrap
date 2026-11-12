---
name: build-app
description: Développe {{NOM_PROJET}} palier par palier selon docs/11-paliers.md, en validant chaque palier par des commandes exécutables, jusqu'à une livraison prête à déployer (artefact versionné, vérifié par release-check, guide docs/14-deploiement.md). À utiliser pour démarrer ou reprendre le développement, réaliser un palier précis, préparer une livraison, ou en mode autopilote. Ne déploie jamais : le déploiement est fait par l'utilisateur.
---

# Développement par paliers — {{NOM_PROJET}}

Réglages du projet (définis au cadrage) :

- **Autonomie :** {{NIVEAU_AUTONOMIE}}
- **Tentatives de correction avant arrêt :** {{MAX_TENTATIVES}}
- **Branche principale :** `{{BRANCHE_PRINCIPALE}}`
- **Branches :** {{STRATEGIE_BRANCHES}} (voir section 3)
- **Vérification après chaque tâche :** `{{CMD_CHECK}}` (toutes les commandes passent par le lanceur de tâches, voir `CLAUDE.md`)
- **Vérification d'une livraison :** `{{CMD_RELEASE_CHECK}}` (voir section 6)
- **Déploiement :** fait par l'utilisateur à partir de `docs/14-deploiement.md`, jamais par l'agent.

L'objectif est une application livrée : le dernier palier du MVP, « Livraison », produit une version que l'utilisateur déploie lui-même sans avoir à deviner quoi que ce soit.

## 1. Démarrage de session

1. Lis `CLAUDE.md`, `PLAN.md` et `docs/11-paliers.md`. Si la demande précise « mode autopilote », applique aussi la section 8.
2. Si la section « Blocages » de `PLAN.md` contient un blocage non résolu, présente-le et attends la réponse de l'utilisateur avant toute autre action (en mode autopilote : termine la session).
3. Vérifie que le dossier est un dépôt git et que `git status` est propre. Sinon, présente les fichiers non commités et demande s'il faut les commiter (par exemple le cadrage initial) avant de commencer. Si le tag `tier-0` n'existe pas, crée-le sur le dernier commit de `{{BRANCHE_PRINCIPALE}}` (`git tag tier-0 {{BRANCHE_PRINCIPALE}}`).
4. Un palier dont le commit de clôture existe sans tag `tier-N` attend sa fusion (vérifie avec `git tag --list "tier-*"` et `git log --all --oneline -F --grep "chore(tier-N): palier validé"`, quelle que soit la branche courante). Termine-le selon la section 3 (« Reprise d'un palier en attente ») avant tout le reste.
5. Le palier courant est le premier palier non coché de `PLAN.md`. Si l'utilisateur demande un palier précis, vérifie que ses prérequis (« Dépend de ») sont cochés ; sinon signale-le et arrête-toi.
6. Lis uniquement les documents listés dans « Docs à lire » pour ce palier, plus les ADR qu'ils citent.
7. Place-toi sur la branche de travail du palier (section 3).

## 2. Boucle d'un palier

**a. Planifier.** Sous le palier dans `PLAN.md`, écris la liste des tâches : petites (une fonctionnalité, une migration, un endpoint, un écran), ordonnées, chacune avec le `F-xx`, `RG-xx` ou `ENF-xx` qu'elle sert. Commite `PLAN.md`.

**b. Réaliser chaque tâche en commençant par ses tests.** Pour chaque tâche, dans l'ordre :
1. Écris les tests qui traduisent ses critères d'acceptation et règles métier, cas limites compris, et vérifie qu'ils échouent. Ces tests matérialisent la spécification : tu ne les affaibliras plus ensuite, sauf si la spécification change avec l'accord de l'utilisateur.
2. Implémente jusqu'à ce qu'ils passent. Un point que la spécification ne tranche pas se traite selon la section 5.
3. Lance `{{CMD_CHECK}}` : tout doit être vert, tests des tâches précédentes compris.
4. Coche la tâche dans `PLAN.md` et commite au format Conventional Commits : `feat(tier-N): <résumé>` (ou `fix`, `test`, `refactor`, `chore`, `docs`).

Les tâches d'infrastructure sans comportement testable unitairement (outillage, Docker, CI) sont validées par une commande qui prouve qu'elles fonctionnent. Les exigences `ENF-xx` du palier sont vérifiées par la méthode prévue dans `docs/02-specifications-fonctionnelles.md` (commande, test de charge, mesure).

**Preuve d'échec.** Au palier 1, puis chaque fois qu'un outil de contrôle est ajouté ou reconfiguré, prouve que `{{CMD_CHECK}}` détecte vraiment les problèmes. Introduis temporairement, une à la fois, une erreur de formatage, une erreur de lint et un test qui échoue ; vérifie que `{{CMD_CHECK}}` renvoie un code non nul à chaque fois ; rétablis le fichier et vérifie que `{{CMD_CHECK}}` repasse au vert. Ne commite aucune de ces erreurs. Note le résultat dans le journal de `PLAN.md`. Si une erreur passe inaperçue, corrige la configuration de l'outil ou la cible du lanceur avant d'aller plus loin.

**c. Valider.** Lance **toutes** les commandes du bloc « Commandes de validation » du palier, dans l'ordre. Toutes doivent réussir (code de sortie 0).

**d. Corriger.** En cas d'échec, analyse la cause et corrige le code (jamais les tests ni la configuration des outils de qualité). Au-delà de {{MAX_TENTATIVES}} tentatives infructueuses sur le même échec :
- écris dans « Blocages » de `PLAN.md` : la commande, l'erreur, les hypothèses testées, la question à trancher ;
- commite ;
- arrête-toi et présente le blocage à l'utilisateur.

**e. Faire relire.** Lance le subagent `tier-reviewer` en lui donnant le numéro du palier. Corrige tous les points « bloquant » et « majeur », puis relance la validation (étape c). Les points « mineur » vont dans `PLAN.md` comme tâches pour plus tard.

**f. Clôturer.**
- Si l'implémentation s'écarte de la documentation, mets la documentation à jour ; si l'écart touche une décision, rédige un ADR et demande sa validation.
- Pour le palier « Livraison » et tout palier qui le suit, applique la section 6 avant de clôturer.
- Coche le palier dans `PLAN.md` et ajoute une ligne au journal.
- Commite `chore(tier-N): palier validé`.

**g. Point d'arrêt.** Arrête-toi et présente un compte rendu si le palier est marqué « Point d'arrêt humain : oui », si le niveau d'autonomie impose un arrêt après chaque palier, ou si le palier produit une livraison (section 6) : une livraison est toujours un point d'arrêt. Avec la stratégie « pull request », c'est la pull request qui sert de point d'arrêt : passe directement à l'étape h.

Le compte rendu tient en quelques lignes : ce qui a été livré, la sortie résumée des validations, les écarts et ADR, les décisions prises seul depuis le dernier compte rendu (section 5), les points mineurs reportés, le palier suivant. Pour une livraison, utilise le compte rendu de la section 6. Si l'utilisateur demande des corrections, reprends à l'étape b sur la même branche, puis repasse par c à f.

**h. Terminer.** Avec le feu vert de l'utilisateur, ou directement s'il n'y avait pas de point d'arrêt, termine le palier selon la stratégie de branches (section 3) : la fusion et le tag `tier-N` marquent le palier comme terminé. Pour une livraison, pose aussi le tag de version (section 6). Enchaîne ensuite sur le palier suivant si le niveau d'autonomie le permet.

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
- Passe toujours par les cibles du lanceur de tâches, jamais par les outils directement. Le hook git `pre-commit` lance `{{CMD_CHECK}}` : un commit refusé se corrige, il ne se contourne jamais (`--no-verify` est interdit).
- Quand un hook de `.claude/hooks/` refuse une action, qu'une règle demande confirmation ou qu'une permission est refusée, ne cherche jamais à passer par un autre chemin (commande shell, autre fichier, autre outil) : explique ce que tu voulais faire et demande à l'utilisateur.
- Ne passe jamais au palier suivant avec une validation en échec, ni avant que le palier courant ait son tag `tier-N`.
- N'invente aucune fonctionnalité absente de `docs/02-specifications-fonctionnelles.md`. Un point non spécifié se traite selon la section 5.
- Ne change ni la stack, ni une dépendance majeure, ni le modèle de données, ni l'architecture sans ADR validé par l'utilisateur.
- Pour toute tâche d'interface, ouvre la maquette de l'écran concerné (`docs/12-maquettes.md` → `design/ecrans/ecr-NN.html`) et reproduis sa structure, ses libellés et ses états. Le thème de l'application reprend les variables de `design/tokens.css`. Tout écart volontaire est noté dans `PLAN.md` et validé par l'utilisateur.
- Les migrations de base sont versionnées et passent par l'outil prévu dans `docs/05-modele-donnees.md`.
- Aucun secret dans le code ni dans les commits : uniquement des variables documentées dans `.env.example`. Si un nouveau fichier généré ou local apparaît dans `git status`, ajoute-le à `.gitignore` plutôt que de le commiter.
- Ne pousse jamais sur `{{BRANCHE_PRINCIPALE}}` et ne réécris jamais son historique ; seule la stratégie « pull request » autorise un push, celui de la branche du palier.
- **Ne déploie jamais et ne publie rien** : aucune connexion à un serveur, aucun push d'image ou de paquet vers un registre, aucune commande sur un environnement distant, aucun push de tag de version. Le déploiement est fait par l'utilisateur ; ton rôle s'arrête à une livraison vérifiée et à son guide (section 6).
- N'agis jamais sur les environnements : {{ENVS_INTERDITS}}.

## 5. Décisions en cours de route

Pour avancer sans surveillance, distingue deux sortes de points que la spécification ne tranche pas.

**Décision bloquante : arrête-toi.** Consigne-la dans « Blocages » de `PLAN.md` avec deux options et ta recommandation, commite et demande. Est bloquant tout ce qui :
- ajoute ou change une fonctionnalité, un rôle, un écran, une règle métier ou un critère d'acceptation ;
- touche la sécurité, les autorisations, les données personnelles, la conservation ou la suppression de données ;
- change la stack, une dépendance majeure, le modèle de données ou l'architecture (ADR) ;
- s'écarte d'une maquette sur un élément visible d'un parcours ;
- serait coûteux à défaire une fois l'application déployée (contrat d'API publique, schéma de données, format de fichier échangé).

**Décision mineure : décide seul et continue.** Par exemple : un libellé ou un message d'erreur non spécifié, un ordre de tri par défaut, une taille de page, un nommage interne, une bibliothèque mineure et répandue, un détail de mise en page absent de la maquette, un cas limite technique dont toutes les options respectent la spécification. Choisis l'option la plus prudente et la plus facile à changer (la plus restrictive pour les droits, la plus conservatrice pour les données, la plus simple pour le code), puis ajoute une ligne à « Décisions à confirmer » de `PLAN.md` :

`- <date> · palier N · <question> → <choix retenu> (alternative : <autre option>) · <fichiers concernés>`

En cas de doute entre les deux, la décision est bloquante. L'utilisateur relit la liste à chaque compte rendu ; une ligne qu'il valide ou corrige est retirée de la liste et notée au journal.

## 6. Livraison

Le palier « Livraison » (dernier palier du MVP dans `docs/11-paliers.md`) et chaque palier qui le suit produisent une version que l'utilisateur déploie lui-même. L'agent prépare et vérifie ; il ne déploie pas.

1. **Version.** SemVer, écrite à un seul endroit : le manifeste de la stack (`package.json`, `.csproj`, `pyproject.toml`, `Cargo.toml`…). La première livraison prend la version prévue dans `docs/14-deploiement.md`. Ensuite : version mineure pour un palier de fonctionnalités, corrective pour des correctifs seuls, majeure si l'utilisateur doit faire plus qu'appliquer la procédure de mise à jour (rupture de contrat d'API, migration manuelle).
2. **Artefact.** `{{CMD_RELEASE}}` construit l'artefact décrit dans `docs/14` (image Docker `<nom>:<version>`, archive, binaire, paquet), étiqueté avec la version et reproductible depuis le tag. Il reste local : aucun push vers un registre.
3. **Configuration de production d'exemple.** Le fichier prévu dans `docs/14` (par exemple `compose.prod.yml`) et un `.env.example` complet : chaque variable lue par le code y figure, commentée, avec la façon de générer les secrets (`openssl rand -hex 32`…), sans aucune vraie valeur.
4. **Preuve que la livraison fonctionne.** `{{CMD_RELEASE_CHECK}}` doit, et le palier « Livraison » crée cette cible :
   - construire l'artefact de production ;
   - le démarrer en local dans des conditions proches de la production : configuration de production d'exemple, variables fictives, base vide dédiée, sans dépendance de développement ;
   - appliquer toutes les migrations sur cette base vide, puis, s'il existe une version précédente (tag `v*`), vérifier aussi la mise à jour depuis cette version ;
   - lancer des tests de fumée contre l'artefact démarré : `/health` (ou équivalent) et les parcours critiques de `docs/02` ;
   - tout arrêter et nettoyer, et renvoyer un code non nul au moindre échec.
   La première fois, fais la preuve d'échec : casse temporairement le endpoint de santé, vérifie que `{{CMD_RELEASE_CHECK}}` échoue, rétablis-le. Note le résultat au journal.
5. **Guide de déploiement.** Complète `docs/14-deploiement.md` : remplace chaque mention « Rédigé au palier de livraison. » par le contenu réel. Version livrée (numéro, date, tag, artefact), première installation (prérequis, configuration, commandes dans l'ordre), mise à jour (sauvegarde préalable, migrations, nouvelles variables), vérification après déploiement (commandes et résultat attendu), retour arrière (version précédente, réversibilité des migrations, restauration de la sauvegarde). Chaque commande du guide est exercée par `{{CMD_RELEASE_CHECK}}` ou marquée « à faire par toi » quand elle dépend du serveur (DNS, TLS, pare-feu, accès à la base de production).
6. **Notes de version.** `CHANGELOG.md` : une section par version, rédigée depuis les commits `feat` et `fix` depuis le tag précédent, avec en tête ce qui demande une action au déploiement (migrations, nouvelles variables, changement de configuration).
7. **Commit et tag.** Commite `chore(release): vX.Y.Z`. En terminant le palier (étape h), pose le tag annoté `vX.Y.Z` sur le même commit que `tier-N`. Ne pousse jamais ce tag : c'est l'utilisateur qui le publie.
8. **Compte rendu de livraison**, toujours présenté, quel que soit le niveau d'autonomie :
   - version, tag et commande pour reconstruire l'artefact ;
   - résultat de `{{CMD_RELEASE_CHECK}}` (étapes et durée) ;
   - ce qui demande une action au déploiement : migrations, variables nouvelles ou modifiées ;
   - les « Décisions à confirmer » de `PLAN.md`, en liste ;
   - les points mineurs reportés ;
   - le lien vers `docs/14-deploiement.md` et la première commande à lancer sur le serveur.

## 7. Gestion du contexte

À la fin de chaque palier, si la session est longue, propose à l'utilisateur de continuer dans une nouvelle session : `PLAN.md`, les tags `tier-N` et l'historique git suffisent pour reprendre exactement au même endroit. Pour enchaîner les sessions sans intervention, l'utilisateur lance `bash .claude/scripts/autopilote.sh` (section 8).

## 8. Mode autopilote

Quand la demande précise « mode autopilote », la session a été lancée par `.claude/scripts/autopilote.sh` et personne ne peut répondre. Le script relance une nouvelle session tant qu'il reste des paliers et qu'aucune intervention humaine n'est nécessaire.

- Réalise **au plus un palier** par session, depuis l'état courant (section 1), puis termine la session par un résumé de quelques lignes. Une session neuve par palier garde le contexte léger.
- Ne pose jamais de question et n'attends jamais de réponse. Tout ce qui demanderait l'utilisateur (décision bloquante, blocage après {{MAX_TENTATIVES}} tentatives, validation d'un ADR, permission refusée, règle `ask` de `.claude/settings.json`) est consigné dans « Blocages » de `PLAN.md` et commité, puis la session se termine.
- Les décisions mineures se prennent seul (section 5) : c'est ce qui permet d'avancer.
- À un point d'arrêt (étape g), arrête-toi après le commit de clôture, sans fusion ni tag : le script détecte le palier en attente et rend la main à l'utilisateur. Une livraison est toujours un point d'arrêt.
- Chaque session doit laisser au moins un commit : le script s'arrête sinon.
