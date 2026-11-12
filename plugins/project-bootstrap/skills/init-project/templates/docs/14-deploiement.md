# 14 — Déploiement

<!-- AIDE : ce guide s'adresse à la personne qui déploie : l'agent ne déploie jamais. Au cadrage, remplis « Cible » et « Livrable ». Laisse telles quelles les sections dont le texte est « Rédigé au palier de livraison. » : build-app les complète au palier « Livraison », avec des commandes vérifiées par la cible release-check, et la validation de ce palier échoue tant que cette phrase reste. -->

Le déploiement est fait par l'utilisateur. L'agent livre une version vérifiée par `{{CMD_RELEASE_CHECK}}` et tient ce guide à jour ; il n'agit jamais sur un environnement distant.

## Cible

| Élément | Valeur |
|---|---|
| Hébergement | {{HEBERGEMENT}} |
| Système | {{OS_CIBLE}} |
| Exécution | {{MODE_EXECUTION}} |
| Base de données | {{BASE_PRODUCTION}} |
| Exposition | {{EXPOSITION}} |
| Environnements | {{ENVIRONNEMENTS}} |

<!-- AIDE : Hébergement : VM de l'organisation, serveur dédié, PaaS… Exécution : Docker Compose, service systemd, conteneur sur PaaS, binaire… Base : même serveur, service géré, version. Exposition : reverse proxy, TLS, nom de domaine. Environnements : par exemple recette puis production. -->

## Livrable

| Élément | Valeur |
|---|---|
| Artefact | {{ARTEFACT}} |
| Construction | `{{CMD_RELEASE}}` |
| Vérification | `{{CMD_RELEASE_CHECK}}` |
| Configuration de production d'exemple | {{FICHIER_CONFIG_PROD}} |
| Versionnement | SemVer, première version `{{PREMIERE_VERSION}}`, tag git `vX.Y.Z` posé par l'agent et publié par l'utilisateur |

<!-- AIDE : Artefact : image Docker `nom:version`, archive `dist/nom-version.tar.gz`, binaire, paquet. Configuration de production d'exemple : par exemple `compose.prod.yml` et `.env.example`. -->

## Version livrée

Rédigé au palier de livraison.

## Première installation

Rédigé au palier de livraison.

## Mise à jour

Rédigé au palier de livraison.

## Vérification après déploiement

Rédigé au palier de livraison.

## Retour arrière

Rédigé au palier de livraison.
