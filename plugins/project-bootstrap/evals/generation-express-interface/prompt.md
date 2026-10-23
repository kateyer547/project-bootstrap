---
description: En mode Express, sans utilisateur, une application web avec interface obtient des maquettes cliquables cohérentes avec la spécification, sans code applicatif.
tags: [lourd]
runs: 1
max_turns: 200
timeout_seconds: 3600
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit]
append_system_prompt: "Aucun utilisateur n'est disponible pendant cette session. Quand le skill demande une réponse ou une validation, retiens toi-même l'option recommandée, considère-la comme validée et continue jusqu'à la génération complète des fichiers. Bash n'est pas disponible : saute les étapes qui en dépendent (git init, captures, script de vérification) et cite-les dans ton message final."
---

Lance le cadrage de mon nouveau projet en mode Express. C'est une application web pour la petite salle d'escalade associative où je suis bénévole. Les adhérents s'inscrivent aux créneaux d'encadrement (12 places max par créneau), les bénévoles publient les créneaux et pointent les présents, et le bureau voit les statistiques de fréquentation par mois. Un adhérent dont la cotisation est expirée ne peut plus s'inscrire. Je n'ai pas de préférence de stack, hébergement le moins cher possible, je développe seul avec des agents.
