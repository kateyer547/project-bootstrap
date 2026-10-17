# 06 — Architecture

- **Style global :** {{STYLE_GLOBAL}}
- **Organisation du code :** {{ORGANISATION_CODE}}
- **Dépôt :** {{MONO_OU_MULTI_REPO}}

## Vue d'ensemble

```mermaid
flowchart LR
    {{COMPOSANT_A}} --> {{COMPOSANT_B}}
```

## Composants

| Composant | Responsabilité | Technologie | Communique avec |
|---|---|---|---|
| {{COMPOSANT}} | {{RESPONSABILITE}} | {{TECHNO}} | {{DEPENDANCES}} |

## Couches et règles de dépendance

{{COUCHES}}
<!-- AIDE : liste des couches et sens autorisé des dépendances, ex. « Api → Application → Domaine ; Infrastructure → Application ; le Domaine ne dépend de rien ». -->

## Arborescence cible

```
{{ARBORESCENCE}}
```

## API

- **Style :** {{STYLE_API}}
- **Contrat :** {{CONTRAT_API}}
- **Préfixe et versionnement :** {{VERSIONNEMENT_API}}
- **Nommage des routes :** {{NOMMAGE_ROUTES}}
- **Pagination, filtres, tri :** {{PAGINATION}}

| Méthode | Route | Fonctionnalité | Rôles autorisés |
|---|---|---|---|
| {{METHODE}} | {{ROUTE}} | {{F_ID}} | {{ROLES}} |

## Gestion des erreurs

{{GESTION_ERREURS}}
<!-- AIDE : format de réponse (ex. RFC 9457 Problem Details), correspondance exceptions → codes HTTP, codes d'erreur métier. -->

## Communication interne

{{COMMUNICATION_INTERNE}}

## Configuration

{{CONFIGURATION}}
<!-- AIDE : variables d'environnement (renvoyer à .env.example), fichiers par environnement, chargement des secrets. -->

## Observabilité applicative

- **Logs :** {{FORMAT_LOGS}}
- **Corrélation :** {{CORRELATION}}
- **Healthcheck :** {{HEALTHCHECK}}
- **Métriques :** {{METRIQUES}}

## Performance

{{PERFORMANCE}}

## Questions ouvertes

{{QUESTIONS_OUVERTES}}
