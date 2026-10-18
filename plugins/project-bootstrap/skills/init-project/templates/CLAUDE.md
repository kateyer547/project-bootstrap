# {{NOM_PROJET}}

{{PITCH_UNE_PHRASE}}

<!-- AIDE : ce fichier est chargé à chaque session. Reste sous ~120 lignes : tout le détail vit dans docs/. -->

## Stack

{{STACK_RESUME}}
<!-- AIDE : liste courte « couche : technologie version », ex. « Backend : C# / ASP.NET Core 9 ». -->

## Commandes

Toutes les commandes passent par le lanceur de tâches **{{LANCEUR}}** (`{{FICHIER_LANCEUR}}`) : lance ses cibles, jamais les outils directement. Une commande qui manque devient d'abord une cible du lanceur (voir le contrat d'outillage de `docs/03-stack-technique.md`).

| Action | Commande |
|---|---|
| Installer les dépendances et le hook git | `{{CMD_INSTALL}}` |
| **Tout vérifier (avant chaque commit)** | `{{CMD_CHECK}}` |
| Lancer les dépendances locales | `{{CMD_DEPS_UP}}` |
| Lancer l'application | `{{CMD_RUN}}` |
| Formater | `{{CMD_FORMAT}}` |
| Lint / analyse statique | `{{CMD_LINT}}` |
| Tests unitaires | `{{CMD_TEST_UNIT}}` |
| Tests d'intégration | `{{CMD_TEST_INTEGRATION}}` |
| Tests E2E | `{{CMD_TEST_E2E}}` |
| Build | `{{CMD_BUILD}}` |
| Nouvelle migration | `{{CMD_MIGRATION_ADD}}` |
| Appliquer les migrations | `{{CMD_MIGRATION_APPLY}}` |

<!-- AIDE : chaque commande est une cible du lanceur (ex. `just test`). `check` enchaîne au minimum le formatage en mode vérification, le lint, les tests unitaires et le build, et s'arrête au premier échec avec un code non nul. La commande d'installation active aussi le hook git : `git config core.hooksPath .githooks`. -->

## Structure du dépôt

```
{{ARBORESCENCE}}
```

## Conventions

{{CONVENTIONS}}
<!-- AIDE : nommage (fichiers, classes, tables, routes), organisation des tests, format des erreurs d'API, logs, Conventional Commits, langue du code et des commentaires. -->

## Documentation de référence

Lis uniquement ce qui est utile à la tâche en cours :

- `docs/00-index.md` : sommaire et glossaire
- `docs/02-specifications-fonctionnelles.md` : fonctionnalités `F-xx`, règles `RG-xx`, critères d'acceptation
- `docs/05-modele-donnees.md` : entités, relations, contraintes
- `docs/06-architecture.md` : couches, contrat d'API, gestion des erreurs
- `docs/11-paliers.md` : étapes de réalisation et commandes de validation
- `docs/adr/` : décisions d'architecture et leurs raisons

## Méthode de travail

- Le développement suit le skill **build-app**, palier par palier. L'avancement est dans `PLAN.md`.
- Un bug signalé passe par le skill **fix-bug** (test qui reproduit d'abord), une fonctionnalité absente de `docs/02` par le skill **add-feature** (spécification et palier avant tout code).
- Une tâche n'est terminée que lorsque `{{CMD_CHECK}}` et les commandes de validation passent. Le hook git `pre-commit` lance `{{CMD_CHECK}}` : un commit refusé se corrige, il ne se contourne pas.
- Toute décision qui modifie la stack, le modèle de données ou l'architecture passe par un nouvel ADR, validé par l'utilisateur avant d'être appliqué.
- En cas d'ambiguïté dans la spécification : s'arrêter et demander, ne pas inventer.

## Interdits

- Modifier ou supprimer un test, désactiver une règle de lint ou marquer un test comme ignoré pour faire passer une validation.
- Écrire un secret en clair ailleurs que dans un fichier `.env` local non versionné.
- Agir sur les environnements : {{ENVS_INTERDITS}}.
- `git push --force`, réécriture de l'historique de la branche principale, `--no-verify` sur un commit ou un push.
- Ajouter une dépendance majeure sans la justifier dans `PLAN.md`.
- Contourner un hook de `.claude/hooks/` ou une règle de `.claude/settings.json` par un autre chemin (commande shell, autre outil) : demander à l'utilisateur.
{{INTERDITS_SPECIFIQUES}}
