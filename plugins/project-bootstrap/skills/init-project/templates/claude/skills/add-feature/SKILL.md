---
name: add-feature
description: Ajoute une fonctionnalité à {{NOM_PROJET}} en mettant à jour la spécification, les maquettes et les paliers avant tout code. À utiliser quand l'utilisateur demande une fonctionnalité, un écran, un champ ou un comportement absent de docs/02-specifications-fonctionnelles.md.
---

# Ajout de fonctionnalité — {{NOM_PROJET}}

Ce skill n'écrit aucun code applicatif : il prépare la fonctionnalité pour que `build-app` la réalise comme un palier, avec la même traçabilité que le reste du projet.

## 1. Vérifier

1. Lis `CLAUDE.md`, `PLAN.md`, `docs/02-specifications-fonctionnelles.md` et `docs/11-paliers.md`.
2. Si la fonctionnalité existe déjà dans `docs/02`, même en partie, dis-le. C'est peut-être un bug (skill `fix-bug`), ou une évolution d'une `F-xx` existante : dans ce cas, modifie cette fonctionnalité au lieu d'en créer une.
3. Si un palier est en cours, demande s'il faut le terminer d'abord. Par défaut, la nouvelle fonctionnalité passe après.

## 2. Entretien court

Pose seulement les questions utiles, 3 au plus par message, avec AskUserQuestion pour les choix fermés (option recommandée en premier) :

- user story, priorité (MVP, V2, plus tard) et critères d'acceptation « Étant donné… quand… alors… » vérifiables par un test ;
- règles métier et cas limites : doublons, suppression d'un élément référencé, accès concurrent, données invalides, service externe indisponible ;
- rôles autorisés, selon la matrice de `docs/02` ;
- exigences non fonctionnelles touchées ou nouvelles, avec une cible chiffrée ;
- impact sur les données (`docs/05`) et sur l'API (`docs/06`) ;
- interface : écran nouveau ou modifié.

Récapitule en 3 à 8 lignes et fais valider.

## 3. Mettre à jour la documentation

- `docs/02` : nouvelle `F-xx` (numéro suivant le plus grand existant), ses `RG-xx`, la matrice des rôles, les `ENF-xx`.
- `docs/05` et son diagramme `erDiagram` si le modèle change ; `docs/06` pour les routes et leurs rôles.
- Toute décision structurante (dépendance majeure, modèle de données, architecture) : un ADR dans `docs/adr/`, validé par l'utilisateur.
- Interface, si `design/` existe : crée ou modifie l'écran `design/ecrans/ecr-NN.html` avec les classes de `design/components.css` et les variables de `design/tokens.css` (aucun style isolé), ses états et ses annotations `data-f`. Déclare-le dans `design/ecrans.js` et `docs/12-maquettes.md`, puis fais valider la maquette avant de continuer.

## 4. Planifier

1. Ajoute un palier à la fin de `docs/11-paliers.md`, au format exact « ## Palier N — Titre », avec objectif, fonctionnalités et exigences, docs à lire, point d'arrêt, dépendances, livrables, commandes de validation (cibles du lanceur de tâches) et critères vérifiés. Si le prochain palier non commencé porte sur le même sujet, propose plutôt d'y ajouter la fonctionnalité.
2. Ajoute la ligne du palier dans `PLAN.md` et une ligne au journal.
3. Lance `bash .claude/scripts/verify-spec.sh` et corrige jusqu'à ce qu'il passe.
4. Commite `docs(spec): ajout de F-xx — <nom>`. Si la stratégie de branches de `build-app` impose une pull request, fais-le sur une branche `spec-F-xx` et ouvre la pull request.

## 5. Passer la main

Présente un résumé (nouvelles `F-xx`, `RG-xx`, `ENF-xx`, ADR, palier ajouté) et propose : « Utilise le skill build-app et réalise le palier N. »
