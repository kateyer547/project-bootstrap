# {{NOM_PROJET}} — Documentation

Cadrage réalisé le {{DATE_DU_JOUR}}. Toute évolution d'une décision passe par un nouvel ADR dans `adr/`.

## Sommaire

| Document | Contenu |
|---|---|
| [01 Vision](01-vision.md) | Problème, utilisateurs, objectifs, contraintes |
| [02 Spécifications fonctionnelles](02-specifications-fonctionnelles.md) | Fonctionnalités `F-xx`, règles métier `RG-xx`, rôles |
| [03 Stack technique](03-stack-technique.md) | Technologies et versions |
| [04 Données](04-donnees.md) | Sources, volumétrie, données personnelles, cycle de vie |
| [05 Modèle de données](05-modele-donnees.md) | Entités, relations, contraintes, migrations |
| [06 Architecture](06-architecture.md) | Composants, couches, API, erreurs, observabilité |
| [07 Sécurité](07-securite.md) | Authentification, autorisation, protections |
| [08 Infrastructure](08-infrastructure.md) | Environnements, hébergement, supervision |
| [09 Déploiement](09-deploiement.md) | CI/CD, mise en production, retour arrière |
| [10 Qualité et tests](10-qualite-tests.md) | Stratégie de tests, outillage, Definition of Done |
| [11 Paliers](11-paliers.md) | Étapes de réalisation et validation |
| [12 Maquettes](12-maquettes.md) | Écrans, parcours, identité visuelle (`design/`) |
| [13 Intégrations](13-integrations.md) | Services externes, bouchons de test, comportement en panne |
| [ADR](adr/) | Décisions d'architecture |

<!-- AIDE : supprime la ligne « 12 Maquettes » si l'application n'a pas d'interface, et la ligne « 13 Intégrations » si elle n'utilise aucun service externe. -->

## Glossaire

| Terme | Définition |
|---|---|
| {{TERME}} | {{DEFINITION}} |

<!-- AIDE : un terme par concept métier, avec le nom exact utilisé dans le code. -->
