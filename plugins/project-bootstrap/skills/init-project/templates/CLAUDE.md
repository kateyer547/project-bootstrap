# {{NOM_PROJET}}

{{PITCH_UNE_PHRASE}}

<!-- AIDE : ce fichier est chargé à chaque session. Reste sous ~120 lignes : tout le détail vit dans docs/. -->

## Stack

{{STACK_RESUME}}
<!-- AIDE : liste courte « couche : technologie version », ex. « Backend : C# / ASP.NET Core 9 ». -->

## Commandes

| Action | Commande |
|---|---|
| Installer les dépendances | `{{CMD_INSTALL}}` |
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
- Une tâche n'est terminée que lorsque les commandes de validation passent.
- Toute décision qui modifie la stack, le modèle de données ou l'architecture passe par un nouvel ADR, validé par l'utilisateur avant d'être appliqué.
- En cas d'ambiguïté dans la spécification : s'arrêter et demander, ne pas inventer.

## Interdits

- Modifier ou supprimer un test, désactiver une règle de lint ou marquer un test comme ignoré pour faire passer une validation.
- Écrire un secret en clair ailleurs que dans un fichier `.env` local non versionné.
- Agir sur les environnements : {{ENVS_INTERDITS}}.
- `git push --force`, réécriture de l'historique de la branche principale.
- Ajouter une dépendance majeure sans la justifier dans `PLAN.md`.
{{INTERDITS_SPECIFIQUES}}
