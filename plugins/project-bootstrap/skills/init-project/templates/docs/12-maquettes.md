# 12 — Maquettes

Les maquettes de `design/` montrent l'application finale attendue. Elles font référence pour tous les paliers d'interface : en cas de doute sur une mise en page, un libellé ou un parcours, c'est la maquette qui tranche, et la spécification fonctionnelle pour le comportement.

## Consulter les maquettes

Ouvrir `design/index.html` dans un navigateur, ou :

```bash
python3 -m http.server 8080 -d design
```

puis `http://localhost:8080`. Le tableau affiche tous les écrans en mobile ou ordinateur, en thème clair ou sombre, avec ou sans annotations des fonctionnalités. Un clic ouvre l'écran en plein écran ; la barre d'outils permet de passer d'un état à l'autre (normal, vide, chargement, erreur).

## Identité visuelle

| Élément | Choix |
|---|---|
| Ambiance | {{AMBIANCE}} |
| Couleur principale | {{COULEUR_PRINCIPALE}} |
| Couleur d'accent | {{COULEUR_ACCENT}} |
| Police | {{POLICE}} |
| Thèmes | {{THEMES}} |
| Densité | {{DENSITE_LIBELLE}} |
| Priorité d'affichage | {{PRIORITE_AFFICHAGE}} |
| Références | {{REFERENCES_VISUELLES}} |

Les valeurs exactes sont dans `design/tokens.css`, à reprendre telles quelles dans le thème de l'application.

## Écrans

| ID | Écran | Fichier | Parcours | Fonctionnalités | Rôles | États |
|---|---|---|---|---|---|---|
| ECR-01 | {{NOM_ECRAN}} | `design/ecrans/ecr-01.html` | {{PARCOURS}} | {{F_IDS}} | {{ROLES}} | {{ETATS}} |

## Parcours

{{PARCOURS_DETAILLES}}
<!-- AIDE : pour chaque parcours critique, la suite d'écrans (ECR-01 → ECR-03 → ECR-04) et l'action qui fait passer de l'un à l'autre. Ces parcours deviennent les scénarios des tests end-to-end. -->

## Règles pour l'implémentation

- Reprendre les variables de `design/tokens.css` comme thème (couleurs, police, rayons, espacements).
- Reproduire la structure, la hiérarchie et les libellés des écrans ; le code n'a pas à copier le HTML des maquettes.
- Chaque état montré (vide, chargement, erreur) doit exister dans l'application.
- Tout écart volontaire avec une maquette est signalé dans `PLAN.md` et validé par l'utilisateur.
