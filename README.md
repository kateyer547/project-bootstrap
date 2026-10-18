# kateyer-plugins

Marketplace Claude Code personnel.

| Plugin | Rôle |
|---|---|
| [project-bootstrap](plugins/project-bootstrap) | Cadre un nouveau projet par entretien, génère toute la documentation et le skill `build-app` qui développe l'application palier par palier. |

## Installation

1. Pousse ce dossier dans un dépôt git (Gitea, GitLab ou GitHub).
2. Dans Claude Code :

   ```
   /plugin marketplace add <url-git-du-depot>
   /plugin install project-bootstrap@kateyer-plugins
   ```

   Pour un dépôt privé, Claude Code utilise tes identifiants git habituels : vérifie qu'un `git clone` de l'URL fonctionne dans ton terminal.

   Pour tester sans dépôt : `/plugin marketplace add /chemin/vers/claude-plugins`.

3. Mise à jour après une modification du plugin : lance `bash tests/run.sh`, incrémente `version` dans `plugins/<plugin>/.claude-plugin/plugin.json` (seul endroit où elle est écrite : c'est elle qui fait foi), pousse, puis `/plugin marketplace update kateyer-plugins`.

## Release

À chaque push sur `main` (ou à la demande, bouton « Run workflow »), le workflow `.github/workflows/package.yml` lance `bash tests/run.sh`. Si la version de `plugin.json` n'a pas encore de Release, il crée la Release GitHub `v<version>` (tag compris) avec `kateyer-plugins-<version>.zip` en pièce jointe et des notes générées depuis les commits. Le zip se télécharge depuis la page **Releases** du dépôt et n'expire pas.

- Sans changement de version, le push ne publie rien : incrémente `version` dans `plugin.json` pour une nouvelle Release.
- Si les tests échouent, aucune Release n'est créée.

## Tester

- `bash tests/run.sh` : contrôles rapides et gratuits (script de vérification, modèles, copies, syntaxe), à lancer à chaque modification.
- `claude plugin eval plugins/project-bootstrap --tag rapide` : évaluation du comportement sur de vraies sessions, payante en jetons, à lancer avant une nouvelle version. Voir [plugins/project-bootstrap/evals/README.md](plugins/project-bootstrap/evals/README.md).

## Utilisation

Dans le dossier d'un nouveau projet (vide, ou avec du code existant) :

```
/project-bootstrap:init-project
```

Ou simplement : « Je démarre un nouveau projet, lance le cadrage. »

Une fois le cadrage terminé :

```
Utilise le skill build-app et commence au palier 1.
```

Voir [plugins/project-bootstrap/README.md](plugins/project-bootstrap/README.md) pour le détail.
