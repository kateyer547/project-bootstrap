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

## Architecture front

- **Routage :** {{ROUTAGE_FRONT}}
- **Gestion d'état :** {{ETAT_FRONT}}
- **Client d'API :** {{CLIENT_API}}
- **Formulaires et validation :** {{VALIDATION_FORMULAIRES}}
- **Erreurs et états vide / chargement :** {{ETATS_FRONT}}
- **Organisation des composants :** {{ORGANISATION_COMPOSANTS}}
- **Traduction et formats :** {{I18N_FRONT}}

<!-- AIDE : supprime la section s'il n'y a pas d'interface. Routage : routes déclarées ou par fichiers, routes protégées par rôle. État : local, store global, cache des requêtes. Client d'API : généré depuis le contrat OpenAPI ou écrit à la main, transmission du jeton. Validation : schéma partagé avec le back ou dupliqué, affichage des messages. Erreurs : traduction du format d'erreur de l'API en messages, page d'erreur, nouvelle tentative. Composants : reprise de design/components.css et design/tokens.css. Traduction : fichiers de traduction, langue par défaut, formats de date, de nombre et de devise. -->

## Questions ouvertes

{{QUESTIONS_OUVERTES}}
