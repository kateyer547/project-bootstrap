# 08 — Infrastructure

- **Hébergement :** {{HEBERGEMENT}}
- **Conteneurisation :** {{CONTENEURISATION}}
- **Infrastructure as Code :** {{IAC}}
- **Coût mensuel visé :** {{COUT}}

## Environnements

| Environnement | Rôle | Hébergement | URL | Déploiement | Accès agent |
|---|---|---|---|---|---|
| local | Développement | Poste + Docker Compose | `{{URL_LOCAL}}` | Manuel | Oui |
| {{ENV}} | {{ROLE}} | {{HEBERGEMENT_ENV}} | `{{URL}}` | {{MODE_DEPLOIEMENT}} | {{ACCES_AGENT}} |

## Schéma

```mermaid
flowchart TB
    {{NOEUD_A}} --> {{NOEUD_B}}
```

## Détail par environnement

### {{ENV}}

- **Machines / services :** {{MACHINES}}
- **Réseau :** {{RESEAU}}
- **Reverse proxy et TLS :** {{PROXY_TLS}}
- **Base de données :** {{BDD_ENV}}

## Développement local

{{DEV_LOCAL}}
<!-- AIDE : services lancés par Docker Compose, ports, initialisation de la base et du seed, devcontainer éventuel. -->

## Supervision

- **Outil :** {{SUPERVISION}}
- **Logs centralisés :** {{LOGS_CENTRALISES}}
- **Alertes et destinataires :** {{ALERTES}}

## Questions ouvertes

{{QUESTIONS_OUVERTES}}
