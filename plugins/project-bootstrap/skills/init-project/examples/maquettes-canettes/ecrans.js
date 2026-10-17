window.PROJET = {
  nom: "Canettes",
  description: "Suivre la collection de canettes du groupe et organiser les échanges"
};

window.ECRANS = [
  { id: "ECR-01", nom: "Connexion", fichier: "ecrans/ecr-01.html", parcours: "Accès", fonctionnalites: ["F-01"], roles: ["membre"], etats: ["normal", "erreur"] },
  { id: "ECR-02", nom: "Ma collection", fichier: "ecrans/ecr-02.html", parcours: "Collection", fonctionnalites: ["F-02", "F-03"], roles: ["membre"], etats: ["normal", "vide", "chargement"] },
  { id: "ECR-03", nom: "Détail d'une canette", fichier: "ecrans/ecr-03.html", parcours: "Collection", fonctionnalites: ["F-04", "F-06"], roles: ["membre"], etats: ["normal"] },
  { id: "ECR-04", nom: "Ajouter une canette", fichier: "ecrans/ecr-04.html", parcours: "Collection", fonctionnalites: ["F-05"], roles: ["membre"], etats: ["normal", "erreur"] },
  { id: "ECR-05", nom: "Le groupe", fichier: "ecrans/ecr-05.html", parcours: "Groupe", fonctionnalites: ["F-07"], roles: ["membre"], etats: ["normal"] }
];
