# Maquettes interactives

Objectif : montrer à l'utilisateur à quoi ressemblera l'application finale **avant** de choisir la stack, comme un prototype Figma. Les maquettes sont des pages HTML statiques, cliquables, ouvertes directement dans le navigateur, sans build ni dépendance.

À faire uniquement si l'application a une interface (web, mobile, desktop). Sinon, saute cette étape et dis-le.

## 1. Lister les écrans

À partir des blocs B et L, propose la liste des écrans et fais-la valider :

| ID | Écran | Fonctionnalités | Rôles | États à montrer |
|---|---|---|---|---|
| ECR-01 | Connexion | F-01 | tous | normal, erreur |
| ECR-02 | Tableau de bord | F-02, F-05 | utilisateur | normal, vide, chargement |

Règles :
- Chaque fonctionnalité `F-xx` du MVP qui a une interface apparaît dans au moins un écran.
- Les parcours critiques du bloc B doivent pouvoir être suivis d'un écran à l'autre en cliquant.
- Une modale ou un formulaire important peut être un écran à part entière.

## 2. Mettre en place le dossier `design/`

Copie depuis `templates/design/` de ce skill :

| Modèle | Destination |
|---|---|
| `index.html` | `design/index.html` (le tableau qui affiche tous les écrans, façon Figma) |
| `ecrans.js` | `design/ecrans.js` (la liste des écrans, lue par `index.html`) |
| `tokens.css` | `design/tokens.css` (couleurs, typographie, rayons, espacements) |
| `components.css` | `design/components.css` (bibliothèque de composants partagée) |
| `proto.js` | `design/proto.js` (barre d'outils : états, thème, annotations) |
| `ecrans/_modele.html` | modèle de départ pour chaque `design/ecrans/ecr-NN.html` ; ne copie pas le modèle lui-même |

Remplis `tokens.css` avec l'identité visuelle du bloc L, et `ecrans.js` avec la liste validée.

## 3. Construire chaque écran

Niveau de finition attendu : ouvre l'exemple `examples/maquettes-canettes/` de ce skill (une application de collection de canettes, 5 écrans). Inspire-toi de sa densité, de ses données crédibles et de sa cohérence visuelle, mais n'en reprends ni le contenu ni la mise en page : chaque projet a sa propre identité.


- **Données réalistes** : contenu en français, cohérent avec le métier, crédible (noms, dates, montants, statuts variés). Jamais de « Lorem ipsum » ni de « Titre 1 ».
- **Mise en page complète** : navigation, en-tête, contenu, actions. L'écran doit ressembler à un vrai produit fini, pas à un fil de fer.
- **Composants partagés** : utilise les classes de `components.css`. Si un composant manque, ajoute-le dans `components.css` (jamais de style isolé dans un écran), pour que tous les écrans restent cohérents.
- **Couleurs et typographie** uniquement via les variables de `tokens.css`, pour que le thème clair et sombre fonctionne partout.
- **Navigation cliquable** : liens et boutons pointent vers l'écran suivant du parcours (`href="ecr-03.html"`). Un formulaire envoyé mène à l'écran de résultat.
- **États** : chaque état listé est une `<section data-etat="...">`. `normal` est visible par défaut, les autres ont l'attribut `hidden`. La barre d'outils de `proto.js` permet de passer de l'un à l'autre.
- **Annotations** : ajoute `data-f="F-03"` sur les zones qui réalisent une fonctionnalité. Le bouton « Annotations » les fait apparaître.
- **Responsive, mobile d'abord** : l'écran doit être correct à 390 px et à 1280 px de large (navigation basse sur mobile, barre latérale sur ordinateur si c'est le style choisi).
- **Icônes** en SVG inline simples ; aucune bibliothèque externe, aucun framework JavaScript.
- **Accessibilité** : contrastes suffisants, libellés sur les champs, textes alternatifs.

## 4. Vérifier le rendu

Si Node est disponible, capture chaque écran et regarde les images avant de les montrer :

```bash
npx -y playwright@latest install chromium
npx -y playwright@latest screenshot --viewport-size=390,844 --full-page design/ecrans/ecr-01.html design/captures/ecr-01-mobile.png
npx -y playwright@latest screenshot --viewport-size=1280,800 --full-page design/ecrans/ecr-01.html design/captures/ecr-01-desktop.png
```

Lis les captures et corrige : débordements horizontaux, textes coupés, éléments superposés, contrastes faibles, écrans vides ou trop pauvres. Si les captures ne sont pas possibles, relis attentivement le HTML.

## 5. Présenter et itérer

Dis à l'utilisateur d'ouvrir `design/index.html` dans son navigateur (double-clic, ou `python3 -m http.server 8080 -d design` puis `http://localhost:8080`). Le tableau montre tous les écrans côte à côte, en mobile ou en ordinateur, en clair ou en sombre ; un clic sur un écran l'ouvre en plein écran pour suivre les parcours.

Demande ses retours écran par écran et itère. Quand un retour change le comportement de l'application (nouveau champ, nouvelle action, règle différente), mets à jour les `F-xx` et `RG-xx` du bloc B en même temps : la spécification et les maquettes doivent toujours dire la même chose.

Ne passe au bloc C qu'après validation explicite des maquettes.

## 6. Après validation

- `design/captures/` peut être conservé : les captures servent de référence visuelle aux paliers d'interface.
- `design/tokens.css` deviendra la base du thème de l'application réelle.
- Le document `docs/12-maquettes.md` (généré à l'étape 4 du skill) recense les écrans et leurs fonctionnalités.
