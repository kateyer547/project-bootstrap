# 03 — Stack technique

| Couche | Technologie | Version | Justification / ADR |
|---|---|---|---|
| {{COUCHE}} | {{TECHNOLOGIE}} | {{VERSION}} | {{ADR}} |

<!-- AIDE : couvre au minimum runtime, framework backend, accès aux données, base de données, frontend, services annexes, conteneurisation. Supprime les couches sans objet. -->

## Dépendances principales

| Paquet | Rôle | Version |
|---|---|---|
| {{PAQUET}} | {{ROLE}} | {{VERSION}} |

## Outillage

| Usage | Outil | Configuration |
|---|---|---|
| Formatage | {{OUTIL_FORMAT}} | {{FICHIER_CONFIG}} |
| Lint / analyse statique | {{OUTIL_LINT}} | {{FICHIER_CONFIG}} |
| Tests | {{OUTIL_TESTS}} | {{FICHIER_CONFIG}} |
| Couverture | {{OUTIL_COUVERTURE}} | {{FICHIER_CONFIG}} |

## Contrat d'outillage

Source unique des commandes du projet : `CLAUDE.md`, la CI, les paliers (`11`), le `.gitignore`, les permissions et les hooks de `.claude/` reprennent ces valeurs.

- **Lanceur de tâches :** {{LANCEUR}}, fichier `{{FICHIER_LANCEUR}}`

| Cible | Rôle | Commande sous-jacente | Échoue quand |
|---|---|---|---|
| `check` | Tout vérifier avant un commit | {{ENCHAINEMENT_CHECK}} | une des étapes échoue |
| {{CIBLE}} | {{ROLE_CIBLE}} | `{{COMMANDE_CIBLE}}` | {{CONDITION_ECHEC}} |

<!-- AIDE : une ligne par cible (install, check, format, lint, test, test-integration, test-e2e, build, migrations…). Les cibles de vérification sont en mode contrôle : elles ne modifient rien et renvoient un code non nul en cas de problème (ex. `prettier --check`, `dotnet format --verify-no-changes`, `ruff format --check`). Le palier 1 le prouve (voir build-app, « Preuve d'échec »). -->

| Élément | Valeur |
|---|---|
| Formater un seul fichier | `{{CMD_FORMAT_FICHIER}}` |
| Extensions formatées | {{EXTENSIONS_FORMATEES}} |
| Motifs des fichiers de test | {{MOTIFS_FICHIERS_TEST}} |
| Marqueurs d'exclusion de tests | {{MARQUEURS_SKIP}} |
| Fichiers de configuration qualité | {{FICHIERS_CONFIG_QUALITE}} |
| Sorties de build et caches | {{SORTIES_BUILD}} |

<!-- AIDE : la commande de formatage reçoit le chemin du fichier en dernier argument. Motifs de test : globs comme `tests/**`, `*.test.ts`, `*Tests.cs`. Marqueurs : ceux du framework de tests qui excluent ou isolent un test (`.skip(`, `.only(`, `#[ignore]`, `[Fact(Skip`, `@Disabled`, `pytest.mark.skip`, `markTestSkipped`…). Fichiers de configuration : ceux des outils de format, lint et tests (`.editorconfig`, `eslint.config.js`, `phpstan.neon`…). Sorties de build : à reporter dans `.gitignore`. -->

## Versions épinglées

{{VERSIONS_EPINGLEES}}
<!-- AIDE : comment les versions sont fixées (global.json, rust-toolchain.toml, .nvmrc, composer.lock, image Docker taguée…). -->

## Questions ouvertes

{{QUESTIONS_OUVERTES}}
