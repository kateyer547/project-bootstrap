# 05 — Modèle de données

- **Type de base :** {{TYPE_BASE}}
- **SGBD :** {{SGBD}} {{VERSION_SGBD}}
- **Outil de migrations :** {{OUTIL_MIGRATIONS}}

## Conventions

| Sujet | Choix |
|---|---|
| Identifiants | {{TYPE_ID}} |
| Nommage des tables et colonnes | {{NOMMAGE}} |
| Colonnes techniques | {{COLONNES_TECHNIQUES}} |
| Dates | Stockées en UTC, type {{TYPE_DATE}} |
| Suppression | {{SUPPRESSION_LOGIQUE_OU_PHYSIQUE}} |
| Audit des modifications | {{AUDIT}} |
| Multi-tenant | {{MULTI_TENANT}} |

## Diagramme

```mermaid
erDiagram
    {{ENTITE_A}} ||--o{ {{ENTITE_B}} : "{{RELATION}}"
```

## Entités

<!-- AIDE : une sous-section par entité. -->

### E-01 — {{NOM_ENTITE}}

{{DESCRIPTION_ENTITE}} — utilisée par {{F_IDS}}.

| Colonne | Type | Null | Défaut | Contraintes |
|---|---|---|---|---|
| {{COLONNE}} | {{TYPE}} | {{NULL}} | {{DEFAUT}} | {{CONTRAINTES}} |

- **Relations :** {{RELATIONS}} (à la suppression : {{ON_DELETE}})
- **Index :** {{INDEX}}

## Requêtes principales

| Requête | Fréquence | Index utilisé |
|---|---|---|
| {{REQUETE}} | {{FREQUENCE}} | {{INDEX}} |

## Stratégie de migrations

{{STRATEGIE_MIGRATIONS}}
<!-- AIDE : migrations versionnées dans le dépôt, réversibles ou non, appliquées comment et par qui dans chaque environnement. -->

## Questions ouvertes

{{QUESTIONS_OUVERTES}}
