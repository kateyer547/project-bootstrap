# 11 — Paliers de réalisation

<!-- AIDE : un palier = un incrément livrable et vérifiable. Chaque palier a au moins un bloc ```bash de commandes de validation qui renvoient un code non nul en cas d'échec. Chaque F-xx du MVP et chaque ENF-xx doit apparaître dans au moins un palier. Pour un palier d'interface, cite les écrans ECR-xx concernés dans « Docs à lire » et fais suivre aux tests E2E les parcours de docs/12-maquettes.md. Garde exactement le format de titre « ## Palier N — Titre » : build-app et le script de vérification s'appuient dessus. Les commandes de validation appellent les cibles du lanceur de tâches du contrat d'outillage de docs/03 (ex. `just check`, `just test-e2e`), jamais les outils directement. Le palier 1 livre le lanceur et sa cible `check`, le hook git `.githooks/pre-commit` qui lance `check` (activé par `git config core.hooksPath .githooks` dans la commande d'installation) et la preuve d'échec de `check`. Si docs/04 prévoit une reprise de données, un palier dédié l'exécute sur une copie et la valide par les contrôles de comptage. Si docs/13 existe, chaque intégration a ses tests contre son bouchon dans le palier qui l'utilise. -->

## Vue d'ensemble

| Palier | Objectif | Fonctionnalités et exigences | Point d'arrêt |
|---|---|---|---|
| 1 | {{OBJECTIF}} | {{F_IDS}} {{ENF_IDS}} | {{OUI_NON}} |

## Palier 1 — {{TITRE}}

- **Objectif :** {{OBJECTIF}}
- **Fonctionnalités et règles :** {{F_IDS}} {{RG_IDS}}
- **Exigences non fonctionnelles :** {{ENF_IDS}}
- **Docs à lire :** {{DOCS_UTILES}}
- **Point d'arrêt humain :** {{OUI_NON}}
- **Dépend de :** {{PALIERS_PREREQUIS}}

### Livrables

{{LIVRABLES}}

### Commandes de validation

```bash
{{COMMANDES_VALIDATION}}
```

### Critères vérifiés

{{CRITERES}}
<!-- AIDE : ce que les commandes démontrent, et les éventuels critères manuels (à limiter au strict nécessaire). -->
