# 02 — Spécifications fonctionnelles

**Type d'application :** {{TYPE_APPLICATION}}

## Rôles et permissions

| Action | {{ROLE_1}} | {{ROLE_2}} |
|---|---|---|
| {{ACTION}} | ✅ | ❌ |

## Fonctionnalités

<!-- AIDE : une sous-section par fonctionnalité. Priorité : MVP, V2 ou Plus tard. Les critères d'acceptation doivent être vérifiables par un test automatisé. -->

### F-01 — {{NOM_FONCTIONNALITE}}

- **Priorité :** {{PRIORITE}}
- **User story :** En tant que {{ACTEUR}}, je veux {{ACTION}} afin de {{BENEFICE}}.
- **Règles métier :** {{RG_LIEES}}
- **Critères d'acceptation :**
  - Étant donné {{CONTEXTE}}, quand {{EVENEMENT}}, alors {{RESULTAT}}.
- **Cas d'erreur :** {{CAS_ERREUR}}

## Règles métier

| ID | Règle | Fonctionnalités concernées |
|---|---|---|
| RG-01 | {{REGLE}} | {{F_IDS}} |

## Exigences non fonctionnelles

| ID | Catégorie | Exigence | Cible mesurable | Vérification |
|---|---|---|---|---|
| ENF-01 | {{CATEGORIE}} | {{EXIGENCE}} | {{CIBLE}} | {{VERIFICATION}} |

<!-- AIDE : catégories usuelles : performance, disponibilité, volumétrie, sécurité, accessibilité, compatibilité (navigateurs, appareils), exploitabilité, conformité. La cible est chiffrée (ex. « p95 < 300 ms sur GET /api/v1/commandes avec 10 000 commandes », « RGAA AA, 0 erreur axe-core sur les écrans du MVP »). La vérification est une commande, un test ou, à défaut, un contrôle manuel décrit. Chaque ENF-xx est rattachée à au moins un palier de docs/11-paliers.md. -->

## Notifications

{{NOTIFICATIONS}}

## Interface utilisateur

{{INTERFACE}}
<!-- AIDE : écrans principaux, parcours critiques, responsive, accessibilité visée, langues. Supprime la section si l'application n'a pas d'interface. -->

## Hors périmètre

{{HORS_PERIMETRE}}

## Questions ouvertes

{{QUESTIONS_OUVERTES}}
