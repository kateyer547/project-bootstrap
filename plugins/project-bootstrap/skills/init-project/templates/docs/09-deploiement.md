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
