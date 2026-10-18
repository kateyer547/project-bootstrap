---
name: fix-bug
description: Corrige un bug de {{NOM_PROJET}} en le reproduisant d'abord par un test qui échoue. À utiliser quand l'utilisateur signale un bug, une régression, une erreur ou un comportement qui ne correspond pas à la spécification.
---

# Correction de bug — {{NOM_PROJET}}

## 1. Comprendre

1. Lis `CLAUDE.md` et la section « Blocages » de `PLAN.md` : un blocage ouvert passe avant tout.
2. Reformule le bug en une phrase : comportement observé, comportement attendu, et la référence qui fixe l'attendu (`F-xx`, `RG-xx` ou `ENF-xx` de `docs/02-specifications-fonctionnelles.md`, écran `ECR-xx` de `docs/12-maquettes.md`).
3. Si la spécification ne dit pas quel comportement est attendu, ce n'est pas encore un bug. Propose deux options et demande laquelle retenir ; avec l'accord de l'utilisateur, ajoute la règle `RG-xx` ou complète le critère d'acceptation dans `docs/02`, puis continue. Si la demande est en réalité une nouvelle fonctionnalité, passe au skill `add-feature`.

## 2. Branche

Applique la stratégie de branches de `build-app` (section 3) avec une branche `fix-<résumé-court>` au lieu de `tier-N-<titre-court>` : création depuis `{{BRANCHE_PRINCIPALE}}`, puis fusion locale ou pull request selon la stratégie. Un correctif ne reçoit pas de tag `tier-N`.

## 3. Reproduire

Écris un test qui reproduit le bug, au niveau le plus bas qui le montre (unitaire avant intégration, intégration avant E2E), et vérifie qu'il échoue pour la bonne raison. Sans test qui échoue, ne corrige rien : cherche encore, ou demande à l'utilisateur les étapes, les données ou le message d'erreur.

## 4. Corriger

1. Cherche la cause, pas le symptôme, et explique-la en une ou deux phrases.
2. Corrige le code, jamais le test qui reproduit le bug ni les autres tests.
3. Lance `{{CMD_CHECK}}` : tout doit être vert. Au-delà de {{MAX_TENTATIVES}} tentatives infructueuses, consigne un blocage dans `PLAN.md` comme le fait `build-app`, commite et arrête-toi.
4. Commite `fix(<zone>): <résumé>` en citant la référence (`F-xx`, `RG-xx`).

## 5. Relire et clore

1. Lance le subagent `tier-reviewer` sur la plage de commits du correctif (`{{BRANCHE_PRINCIPALE}}..HEAD`). Corrige les points bloquants et majeurs.
2. Ajoute une ligne au journal de `PLAN.md` : date, `fix`, résumé, cause, test ajouté.
3. Termine selon la stratégie de branches, puis présente un compte rendu court : cause, correction, test ajouté, règle de spécification ajoutée le cas échéant.

## Règles

Les règles permanentes de `build-app` (section 4) s'appliquent : aucun test affaibli, aucun contournement des hooks, aucun changement de stack, de modèle de données ou d'architecture sans ADR validé par l'utilisateur.
