# 13 — Intégrations externes

<!-- AIDE : document à créer seulement si l'application appelle des services externes (paiement, e-mail, SMS, SSO, stockage, API métier) ou en reçoit des webhooks. Une sous-section par service. -->

## Vue d'ensemble

| Service | Fournisseur | Fonctionnalités | Sens | Criticité |
|---|---|---|---|---|
| {{SERVICE}} | {{FOURNISSEUR}} | {{F_IDS}} | {{SENS}} | {{CRITICITE}} |

<!-- AIDE : sens = appel sortant, webhook entrant, ou les deux. Criticité = bloquante (l'application ne fonctionne pas sans) ou dégradable (une partie reste utilisable). -->

## {{SERVICE}}

- **Usage :** {{USAGE_SERVICE}}
- **Authentification :** {{AUTH_SERVICE}}, variables {{VARIABLES_SERVICE}} documentées dans `.env.example`
- **Environnement d'essai :** {{ENV_ESSAI_SERVICE}}
- **Tests automatisés :** {{BOUCHON_SERVICE}}
- **Quotas et limites :** {{QUOTAS_SERVICE}}
- **Délai d'attente et nouvelles tentatives :** {{TIMEOUT_SERVICE}}
- **En cas de panne :** {{PANNE_SERVICE}}
- **Webhooks entrants :** {{WEBHOOKS_SERVICE}}

<!-- AIDE : tests automatisés = bouchon ou serveur simulé utilisé par les tests ; la CI n'appelle jamais le vrai service. En cas de panne = ce que voit l'utilisateur et ce qui est rejoué plus tard (file d'attente, tâche planifiée). Webhooks = route, vérification de la signature, traitement idempotent d'un même événement reçu deux fois. -->

## Questions ouvertes

{{QUESTIONS_OUVERTES}}
