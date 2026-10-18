---
description: En mode Express et sans utilisateur pour répondre, init-project génère une documentation complète, sans marqueur restant et sans code applicatif.
tags: [lourd]
runs: 1
max_turns: 150
timeout_seconds: 2400
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit]
append_system_prompt: "Aucun utilisateur n'est disponible pendant cette session. Quand le skill demande une réponse ou une validation, retiens toi-même l'option recommandée, considère-la comme validée et continue jusqu'à la génération complète des fichiers. Bash n'est pas disponible : saute les étapes qui en dépendent (git init, script de vérification, spec-reviewer) et cite-les dans ton message final."
---

Lance le cadrage de mon nouveau projet en mode Express.

C'est une API REST seule, sans interface, pour gérer les prêts de matériel informatique d'une école. Les techniciens enregistrent le matériel (ordinateurs portables, vidéoprojecteurs, tablettes) avec un numéro d'inventaire unique. Les enseignants réservent du matériel disponible pour un créneau. Les techniciens valident la sortie puis le retour, en notant l'état du matériel. Un matériel en panne ne peut plus être réservé jusqu'à sa réparation. Il faut un historique des prêts par matériel et par enseignant.

Stack imposée : Python 3.12 avec FastAPI, PostgreSQL 17, SQLAlchemy et Alembic, pytest. Authentification par l'annuaire LDAP de l'école. Hébergement sur une VM Debian de l'école avec Docker Compose, code sur le GitLab de l'école. Je développe seul avec des agents, mise en service dans trois mois.
