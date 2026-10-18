# 09 — Déploiement et CI/CD

- **Forge :** {{FORGE}}
- **Runners :** {{RUNNERS}}
- **Registre d'artefacts :** {{REGISTRE}}

## Branches et versions

- **Stratégie de branches :** {{STRATEGIE_BRANCHES}}
- **Protection de la branche principale :** {{PROTECTION}}
- **Commits :** {{CONVENTION_COMMITS}}
- **Versionnement :** {{VERSIONNEMENT}}

## Pipeline

```mermaid
flowchart LR
    {{ETAPE_A}} --> {{ETAPE_B}}
```

| Étape | Commande / job | Déclencheur | Bloquante |
|---|---|---|---|
| {{ETAPE}} | `{{COMMANDE}}` | {{DECLENCHEUR}} | {{BLOQUANTE}} |

Fichier de pipeline : `{{FICHIER_PIPELINE}}`

Vérification du pipeline sans pousser : `{{VALIDATION_PIPELINE}}`

<!-- AIDE : chaque étape appelle une cible du lanceur de tâches de docs/03, pour que la CI lance exactement les mêmes commandes que l'agent en local. La vérification du pipeline est une exécution locale (`act` pour GitHub ou Gitea Actions, `gitlab-ci-local`) ou un analyseur (`actionlint`, `glab ci lint`) ; à défaut, écris « première pull request » et le palier 1 le vérifie ainsi. -->

## Déploiement par environnement

| Environnement | Déclenchement | Stratégie | Validation humaine |
|---|---|---|---|
| {{ENV}} | {{DECLENCHEMENT}} | {{STRATEGIE}} | {{VALIDATION}} |

## Migrations de base

{{MIGRATIONS_DEPLOIEMENT}}

## Vérification après déploiement

{{VERIFICATION_POST_DEPLOIEMENT}}

## Retour arrière

{{ROLLBACK}}
<!-- AIDE : procédure pas à pas, délai visé, cas des migrations déjà appliquées. -->

## Variables et secrets de CI

| Nom | Usage | Où il est défini |
|---|---|---|
| {{NOM_VARIABLE}} | {{USAGE}} | {{EMPLACEMENT}} |

## Questions ouvertes

{{QUESTIONS_OUVERTES}}
