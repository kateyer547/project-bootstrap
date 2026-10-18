# 04 — Données

## Sources

| Source | Type | Format | Fréquence | Authentification | Si indisponible |
|---|---|---|---|---|---|
| {{SOURCE}} | {{TYPE}} | {{FORMAT}} | {{FREQUENCE}} | {{AUTH}} | {{COMPORTEMENT}} |

## Volumétrie

| Donnée | Au lancement | À un an | Remarque |
|---|---|---|---|
| {{DONNEE}} | {{VOLUME_INITIAL}} | {{VOLUME_1AN}} | {{REMARQUE}} |

Utilisateurs simultanés attendus : {{UTILISATEURS_SIMULTANES}}

## Données de référence et jeu d'essai

- **Référentiels :** {{REFERENTIELS}}
- **Seed de démonstration :** {{SEED}}
- **Comptes de test (un par rôle) :** {{COMPTES_TEST}}

## Données personnelles

| Donnée | Finalité | Base légale | Conservation | Hors production |
|---|---|---|---|---|
| {{DONNEE_PERSO}} | {{FINALITE}} | {{BASE_LEGALE}} | {{DUREE}} | {{ANONYMISATION}} |

Droits des personnes (accès, export, effacement) : {{DROITS}}

## Données sensibles

{{DONNEES_SENSIBLES}}
<!-- AIDE : ce qui est chiffré au repos, masqué dans les logs, exclu des exports. -->

## Cycle de vie

{{CYCLE_DE_VIE}}
<!-- AIDE : archivage, purge, historisation, suppression logique ou physique. -->

## Reprise de données existantes

- **Source :** {{SOURCE_REPRISE}}, volume {{VOLUME_REPRISE}}
- **Correspondance des champs :** {{CORRESPONDANCE_REPRISE}}
- **Nettoyage et rejets :** {{NETTOYAGE_REPRISE}}
- **Script :** {{SCRIPT_REPRISE}}, rejouable sans créer de doublons
- **Essai à blanc :** {{ESSAI_BLANC_REPRISE}}
- **Contrôles :** {{CONTROLES_REPRISE}}
- **Bascule et retour arrière :** {{BASCULE_REPRISE}}

<!-- AIDE : supprime la section s'il n'y a aucune donnée à reprendre d'un système existant. Correspondance : table ou fichier source → entité E-xx de 05. Nettoyage : règles appliquées et sort des lignes rejetées (fichier de rejets). Essai à blanc : sur une copie des données, avant la mise en production. Contrôles : comptages et sommes comparés entre source et cible, par une commande qui échoue en cas d'écart. Bascule : gel de l'ancien système, reprise finale, retour arrière possible. -->

## Sauvegardes

- **Fréquence :** {{FREQUENCE_SAUVEGARDE}}
- **Rétention :** {{RETENTION}}
- **Stockage :** {{LIEU_SAUVEGARDE}}
- **RPO / RTO :** {{RPO}} / {{RTO}}
- **Test de restauration :** {{TEST_RESTAURATION}}

## Questions ouvertes

{{QUESTIONS_OUVERTES}}
