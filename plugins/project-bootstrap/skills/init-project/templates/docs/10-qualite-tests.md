# 10 — Qualité et tests

## Stratégie de tests

| Niveau | Outil | Ce qui est testé | Commande | Quand |
|---|---|---|---|---|
| Unitaires | {{OUTIL}} | {{PERIMETRE}} | `{{CMD_TEST_UNIT}}` | {{QUAND}} |
| Intégration | {{OUTIL}} | {{PERIMETRE}} | `{{CMD_TEST_INTEGRATION}}` | {{QUAND}} |

<!-- AIDE : ajoute contrat d'API, E2E, charge si retenus. Les tests d'intégration utilisent une vraie base (Testcontainers ou Docker Compose), jamais la base partagée. -->

## Organisation des tests

{{ORGANISATION_TESTS}}
<!-- AIDE : emplacement, nommage, données de test, isolation entre tests. -->

## Couverture

- **Minimum :** {{COUVERTURE_MIN}}
- **Périmètre mesuré :** {{PERIMETRE_COUVERTURE}}
- **Commande :** `{{CMD_COUVERTURE}}`

## Règles bloquantes

{{REGLES_BLOQUANTES}}
<!-- AIDE : formatage, lint, avertissements du compilateur traités comme erreurs, vulnérabilités critiques… -->

## Revue

{{REVUE}}

## Definition of Done

Une fonctionnalité est terminée quand :

{{DEFINITION_OF_DONE}}

## Documentation à maintenir

{{DOCUMENTATION}}
