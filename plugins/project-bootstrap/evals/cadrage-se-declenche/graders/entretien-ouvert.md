---
type: llm
focus: trace
---

PASS si Claude ouvre un entretien de cadrage : il demande à l'utilisateur de choisir un rythme (Express ou Complet) ou lui pose au moins une question sur la vision, les utilisateurs ou les fonctionnalités, par l'outil AskUserQuestion ou dans son message.
FAIL si Claude écrit du code, impose une stack technique sans rien demander, ou termine sans poser aucune question à l'utilisateur.
