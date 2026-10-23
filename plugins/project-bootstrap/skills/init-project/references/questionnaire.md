# Questionnaire de cadrage

Chaque bloc indique le ou les documents qu'il alimente. Ce questionnaire est une grille, pas un script : les questions et les options listées sont des points de départ. Adapte-les au contexte et aux réponses déjà données, place toujours ta recommandation en premier, et ajoute toute question ou option que le projet appelle même si elle n'est pas listée. Les questions marquées **(ouverte)** se posent en texte libre.

À la fin de chaque bloc, avant le récapitulatif, propose tes **idées** (voir « Force de proposition » dans `SKILL.md`).

En mode Express, utilise ce questionnaire comme grille : pré-remplis chaque question à partir du paragraphe de l'utilisateur, puis fais valider le bloc entier en une fois en signalant ce que tu as déduit et ce que tu as supposé.

---

## A. Contexte et vision → `docs/01-vision.md`

1. **(ouverte)** Nom du projet et pitch en une phrase.
2. **(ouverte)** Quel problème résout-il, et pour qui ? Qu'est-ce qui se passe aujourd'hui sans l'application ?
3. **(ouverte)** Qui sont les utilisateurs ? Pour chaque profil : rôle, besoin principal, fréquence d'usage, niveau technique.
4. Cadre du projet : académique / professionnel / personnel / open source.
5. Échéance : date de rendu ou de mise en production, et jalons intermédiaires imposés.
6. Équipe : seul / petite équipe (qui fait quoi) / agents uniquement.
7. Contraintes imposées : technologies obligatoires ou interdites, budget d'hébergement, infrastructure existante à réutiliser, normes (RGPD, accessibilité, charte graphique).
8. **(ouverte)** Comment saura-t-on que le projet est réussi ? (2 à 4 critères mesurables)

## B. Périmètre fonctionnel → `docs/02-specifications-fonctionnelles.md`

1. Type d'application : API seule / application web / web + API / mobile + API / desktop / CLI / plusieurs.
2. **(ouverte)** Liste des fonctionnalités. Pour chacune, obtenir :
   - un identifiant `F-xx` et un nom court ;
   - l'acteur, l'action, le résultat attendu (format user story) ;
   - la priorité : MVP / V2 / plus tard ;
   - au moins un critère d'acceptation vérifiable (Given/When/Then).
3. Rôles et permissions : quels rôles existent, et la matrice rôle × action.
4. **(ouverte)** Règles métier `RG-xx` : calculs, statuts et transitions, limites, unicités, délais, cas d'erreur. Relance sur les cas limites (doublons, suppression d'un élément référencé, accès concurrent).
5. Notifications : aucune / e-mail / push / temps réel dans l'interface / webhooks.
6. Interface (si front) : pages ou écrans principaux, parcours critiques, responsive, thème sombre, accessibilité visée (RGAA / WCAG AA). Navigateurs et appareils pris en charge, avec leurs versions minimales. Langues, langue par défaut, formats de date, de nombre et de devise, fuseau d'affichage. Les navigateurs, l'accessibilité et les langues deviendront des `ENF-xx` au bloc K.
7. **(ouverte)** Hors périmètre : ce que l'application ne fera explicitement **pas**.

## L. Identité visuelle et maquettes → `design/`, `docs/12-maquettes.md`

À poser juste après le bloc B, uniquement si l'application a une interface. Les maquettes se construisent ensuite en suivant `references/maquettes.md`.

1. Ambiance : sobre et professionnelle / moderne et colorée / minimaliste / ludique / premium.
2. Couleur principale : code hexadécimal, couleur d'une charte existante, ou « propose ». Couleur d'accent idem.
3. Thèmes : clair seulement / sombre seulement / les deux.
4. Police : système (Recommandé pour la performance) / Inter / Roboto / Poppins / autre police Google Fonts.
5. Forme : angles droits / légèrement arrondis (Recommandé) / très arrondis.
6. Densité : confortable / compacte (outils de gestion avec beaucoup de données).
7. Priorité d'affichage : mobile d'abord / ordinateur d'abord / les deux à égalité.
8. Navigation : barre latérale / barre supérieure / navigation basse sur mobile / combinaison.
9. **(ouverte)** Références : applications ou sites dont le style plaît à l'utilisateur, et ce qu'il aime dedans.
10. **(ouverte)** Logo ou nom affiché, ton des textes (tutoiement ou vouvoiement, formel ou décontracté).
11. Niveau de maquettes : complètes, tous les écrans cliquables (Recommandé si l'application a plusieurs rôles ou parcours) / écran type, un seul écran complet plus la liste des écrans (plus rapide et nettement moins coûteux en jetons).

## C. Stack technique → `docs/03-stack-technique.md`

Pour chaque couche, demande le choix **et la version** :

1. Backend : langage + framework (ex. C# / ASP.NET Core 9, Rust / Axum, PHP / Symfony 7, TypeScript / NestJS, Python / FastAPI, Java / Spring Boot).
2. Accès aux données : ORM / query builder / SQL brut (ex. EF Core, Diesel, SQLx, Doctrine, Prisma).
3. Frontend (si applicable) : framework (React, Vue, Angular, Svelte, Blazor, Twig/SSR), bibliothèque UI, gestion d'état, build tool.
4. Mobile (si applicable) : natif / Flutter / React Native / .NET MAUI / PWA.
5. Services annexes : cache (Redis), file de messages (RabbitMQ, Kafka), recherche (Meilisearch, Elasticsearch), stockage de fichiers (disque, S3, Azure Blob), envoi d'e-mails, tâches planifiées.
6. Gestionnaire de paquets, outil de build, versions de runtime à épingler.
7. Outillage qualité : formatter, linter, analyseur statique, outil de tests, outil de couverture. Pour chaque outil : la commande **en mode vérification**, qui ne modifie rien et renvoie un code non nul en cas de problème, et la commande qui formate un seul fichier.
8. Lanceur de tâches, qui expose toutes les commandes sous des noms stables (`check`, `test`, `lint`…) appelés par `CLAUDE.md`, la CI et les paliers : `just` (Recommandé si la stack n'a pas déjà de scripts natifs : un seul exécutable, multiplateforme) / scripts du gestionnaire de paquets (`npm run`, `composer`) / `make` (non fourni avec Git Bash sous Windows) / script shell.

Les réponses 6 à 8 remplissent le « Contrat d'outillage » de `docs/03`, avec les motifs des fichiers de test, les marqueurs d'exclusion du framework de tests et les sorties de build, que tu déduis de la stack et fais confirmer.

Pour chaque choix structurant, prévois un ADR.

## D. Données → `docs/04-donnees.md`

1. Sources : saisie utilisateur / import de fichiers (CSV, Excel, JSON) / API externes / base existante à migrer / open data / capteurs ou flux.
2. Pour chaque source externe : format, fréquence de mise à jour, authentification, quotas, que faire si elle est indisponible.
3. Volumétrie : nombre d'enregistrements au lancement et à un an, taille des fichiers, nombre d'utilisateurs simultanés.
4. Données de référence et jeu d'essai : listes fixes (pays, catégories, statuts), données de démo (seed), comptes de test par rôle.
5. Données personnelles : lesquelles, base légale, durée de conservation, droit à l'effacement et à l'export, anonymisation en dehors de la production.
6. Données sensibles : ce qui doit être chiffré au repos, masqué dans les logs, exclu des exports.
7. Cycle de vie : archivage, purge, historisation, suppression logique ou physique.
8. Sauvegardes : fréquence, rétention, lieu de stockage, objectif de restauration (RPO / RTO), test de restauration.
9. Reprise de données (si une base ou des fichiers existants sont à reprendre, voir D1) : volume, correspondance avec les entités, nettoyage et rejets, script rejouable, essai à blanc, contrôles par comptage, bascule et retour arrière.

## E. Modélisation des données → `docs/05-modele-donnees.md`

Déduis une première proposition à partir des blocs B et D, puis fais-la valider :

1. Type de base : relationnelle / document / clé-valeur / graphe / mixte (justifier au regard des données).
2. SGBD et version (ex. PostgreSQL 17, SQL Server 2022, MySQL 8.4, MongoDB 8, SQLite).
3. Entités `E-xx` : attributs, types, nullabilité, valeurs par défaut, contraintes (unique, check, longueur).
4. Relations et cardinalités, comportement à la suppression (cascade, restrict, set null).
5. Conventions :
   - identifiants : entier auto-incrémenté / UUID v7 / ULID ;
   - nommage : `snake_case` ou `PascalCase`, singulier ou pluriel ;
   - colonnes techniques : `created_at`, `updated_at`, `deleted_at`, `version` (verrou optimiste) ;
   - fuseau horaire : stockage en UTC.
6. Suppression logique ou physique, et audit des modifications (table d'historique, journal).
7. Multi-tenant : non / colonne `tenant_id` / schéma par client / base par client.
8. Index prévus selon les requêtes principales, et contraintes d'intégrité côté base.
9. Stratégie de migrations : outil, migrations versionnées dans le dépôt, réversibles ou non.

Présente le résultat sous forme de diagramme Mermaid `erDiagram`.

## F. Architecture → `docs/06-architecture.md`, `docs/13-integrations.md`

1. Style global : monolithe modulaire (Recommandé par défaut) / microservices / serverless / monolithe classique.
2. Organisation du code : architecture en couches / hexagonale (ports et adaptateurs) / clean architecture / vertical slices / MVC.
3. Dépôt : mono-repo / un dépôt par composant. Arborescence cible des dossiers.
4. Style d'API : REST / GraphQL / gRPC. Format (JSON), convention de nommage des routes, versionnement (`/api/v1`), pagination, filtrage, tri.
5. Contrat d'API : OpenAPI écrit avant le code (design-first) ou généré depuis le code.
6. Gestion des erreurs : format standard (RFC 9457 Problem Details), codes HTTP, codes d'erreur métier.
7. Communication interne : synchrone / asynchrone par messages / événements.
8. Configuration : variables d'environnement, fichiers par environnement, gestion des secrets.
9. Journalisation et observabilité applicative : format des logs (JSON structuré), niveaux, corrélation des requêtes, endpoint `/health`, métriques.
10. Performance : temps de réponse visés, mise en cache, traitements lourds en tâche de fond.
11. Architecture front (si interface) : routage et routes protégées, gestion d'état, client d'API (généré depuis le contrat OpenAPI ou écrit), validation des formulaires (schéma partagé avec le back ou non), affichage des erreurs de l'API, organisation des composants, fichiers de traduction.
12. Intégrations externes → `docs/13-integrations.md` : paiement, e-mail transactionnel, SMS, SSO, stockage, API métier, webhooks entrants. Pour chacune : fournisseur, environnement d'essai, **bouchon pour les tests automatisés**, quotas, délai d'attente et nouvelles tentatives, comportement en panne, vérification de la signature des webhooks. Les sources externes de D2 appelées par l'application y figurent aussi.

## G. Sécurité → `docs/07-securite.md`

1. Authentification : sessions / JWT / OAuth2-OIDC (Keycloak, Entra ID, Auth0) / Active Directory-LDAP / clés d'API.
2. Autorisation : rôles (RBAC) / attributs (ABAC) / propriété de la ressource. Où est-elle vérifiée ?
3. Mots de passe (si gérés) : algorithme de hachage (Argon2id), politique, réinitialisation, MFA.
4. Protections : validation des entrées, CORS, CSRF, en-têtes de sécurité, limitation de débit, taille maximale des uploads.
5. Secrets : coffre (Vault, Azure Key Vault), variables de CI, rotation.
6. Chiffrement : TLS partout, chiffrement au repos des données sensibles.
7. Traçabilité : journal d'audit des actions sensibles.
8. Contrôles automatisés : analyse des dépendances, SAST, scan des images de conteneurs.

## K. Étapes de réalisation et validation → `docs/11-paliers.md`, `PLAN.md`, `docs/02-specifications-fonctionnelles.md`

Commence par consolider les **exigences non fonctionnelles** `ENF-xx` exprimées dans les blocs précédents : contraintes et normes (A7), accessibilité et compatibilité (B6), volumétrie et utilisateurs simultanés (D3), RPO / RTO (D8), performance (F10), sécurité (G), disponibilité. Pour chacune : une cible mesurable et sa méthode de vérification (commande, test, mesure, ou contrôle manuel décrit). Relance toute exigence sans chiffre (« rapide », « disponible »). Elles vont dans la section « Exigences non fonctionnelles » de `docs/02`.

Propose ensuite un découpage à partir de tout ce qui précède. Base de départ à adapter :

| Palier | Objectif type |
|---|---|
| 1 | Socle : dépôt, structure, outillage qualité, lanceur de tâches avec sa cible `check` et le hook git `pre-commit`, preuve d'échec de `check`, CI minimale si le projet a une forge, endpoint `/health`, environnement local |
| 2 | Données : schéma, migrations, seed, couche d'accès, tests d'intégration |
| 3 | Sécurité : authentification, autorisation, comptes de test |
| 4 à n | Fonctionnalités MVP par lots cohérents (un lot = un ensemble de `F-xx` liés) |
| n+1 | Interface utilisateur et parcours E2E (si front) |
| n+2 | Durcissement : sécurité, performance, observabilité, gestion d'erreurs |
| n+3 | V2 et suivantes |

Pour chaque palier, fais préciser :

1. Les fonctionnalités `F-xx`, règles `RG-xx` et exigences `ENF-xx` couvertes.
2. Les livrables concrets.
3. Les **commandes de validation** : des commandes exécutables qui renvoient un code de sortie non nul en cas d'échec.
4. Les critères manuels éventuels, à limiter au strict nécessaire.
5. Le point d'arrêt humain : oui / non.

Puis, pour l'ensemble du développement :

6. Niveau d'autonomie de l'agent :
   - arrêt après chaque palier (Recommandé pour un premier projet) ;
   - arrêt uniquement aux paliers marqués comme points d'arrêt ;
   - autonomie complète jusqu'au dernier palier, arrêt seulement en cas de blocage.
7. Nombre maximal de tentatives de correction avant arrêt (3 par défaut).
8. Branche principale (`main` par défaut) et sa protection : pull request obligatoire ou non. Puis les branches pendant le développement (si une pull request est obligatoire, recommande la deuxième option) :
   - une branche par palier, fusionnée localement par l'agent dans la branche principale à la clôture du palier (Recommandé) ;
   - une branche par palier poussée sur la forge en pull / merge request, fusionnée par l'utilisateur ;
   - travail direct sur une branche de développement unique, sans fusion par l'agent.
9. Environnements et actions interdits à l'agent (par défaut : aucun accès à la production, pas de `git push --force`, pas de suppression de données hors environnement local).

Vérifie avant de valider : chaque `F-xx` du MVP et chaque `ENF-xx` apparaît dans au moins un palier, et chaque palier a au moins une commande de validation. Les fonctionnalités V2 ou « plus tard » peuvent rester hors paliers.
