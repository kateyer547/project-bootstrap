# my-plugins

Marketplace Claude Code personnel.

| Plugin | Rôle |
|---|---|
| [project-bootstrap](plugins/project-bootstrap) | Cadre un nouveau projet par entretien, génère toute la documentation et le skill `build-app` qui développe l'application palier par palier. |

## Installation

1. Pousse ce dossier dans un dépôt git (Gitea, GitLab ou GitHub).
2. Dans Claude Code :

   ```
   /plugin marketplace add <url-git-du-depot>
   /plugin install project-bootstrap@my-plugins
   ```

   Pour un dépôt privé, Claude Code utilise tes identifiants git habituels : vérifie qu'un `git clone` de l'URL fonctionne dans ton terminal.

   Pour tester sans dépôt : `/plugin marketplace add /chemin/vers/claude-plugins`.

3. Mise à jour après une modification du plugin : incrémente `version` dans `plugin.json` et `marketplace.json`, pousse, puis `/plugin marketplace update my-plugins`.

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
