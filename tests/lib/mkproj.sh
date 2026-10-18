#!/usr/bin/env bash
# Faux projets pour tester verify-bootstrap.sh. À sourcer après assert.sh.

# mkproj <dossier> : projet cadré, complet et valide (sans interface).
mkproj() {
  local p=$1 n
  rm -rf "$p"
  mkdir -p "$p/docs/adr" "$p/.claude/skills/build-app" "$p/.claude/agents"
  (
    cd "$p" || exit 1
    for n in 00-index 01-vision 04-donnees 06-architecture 07-securite 08-infrastructure 09-deploiement 10-qualite-tests; do
      printf '# %s\n\nContenu rempli.\n' "$n" > "docs/$n.md"
    done
    printf "# 03 — Stack technique\n\n## Contrat d'outillage\n\n- **Lanceur de tâches :** just, fichier \`justfile\`\n" > docs/03-stack-technique.md
    cat > docs/02-specifications-fonctionnelles.md <<'EOF'
# 02 — Spécifications fonctionnelles

## Fonctionnalités

### F-01 — Connexion
- **Priorité :** MVP

### F-02 — Export
- **Priorité :** V2

### F-03 — Tableau de bord
- **Priorité :** MVP

#### Détail
Sous-titre de niveau 4 : ne termine pas la fonctionnalité.

## Règles métier

| ID | Règle | Fonctionnalités concernées |
|---|---|---|
| RG-01 | Une seule session active | F-01, F-03 |

## Exigences non fonctionnelles

| ID | Catégorie | Exigence | Cible mesurable | Vérification |
|---|---|---|---|---|
| ENF-01 | Performance | Tableau de bord rapide | p95 < 300 ms | k6 |
EOF
    printf '# 05\n\n```mermaid\nerDiagram\n  UTILISATEUR ||--o{ SESSION : ouvre\n```\n' > docs/05-modele-donnees.md
    cat > docs/11-paliers.md <<'EOF'
# 11 — Paliers de réalisation

## Palier 1 — Socle

- **Fonctionnalités et règles :** F-01 F-03 RG-01
- **Exigences non fonctionnelles :** ENF-01

### Commandes de validation

```bash
just check
```
EOF
    printf '# Projet test\n\n| Action | Commande |\n|---|---|\n| **Tout vérifier (avant chaque commit)** | `just check` |\n' > CLAUDE.md
    printf '# Plan\n' > PLAN.md
    printf 'DATABASE_URL=postgres://app:changeme@localhost:5432/app\n' > .env.example
    printf '.env\n.env.*\n!.env.example\nnode_modules/\n' > .gitignore
    cat > .claude/settings.json <<'EOF'
{
  "permissions": {
    "allow": ["Bash(git status:*)", "Bash(just:*)"],
    "ask": ["Edit(/.claude/**)"],
    "deny": ["Bash(git * --no-verify*)"]
  },
  "hooks": {
    "SessionStart": [{ "hooks": [{ "type": "command", "command": "bash \"${CLAUDE_PROJECT_DIR}/.claude/hooks/session-start.sh\"" }] }],
    "PreToolUse": [{ "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": "bash \"${CLAUDE_PROJECT_DIR}/.claude/hooks/guard-tests.sh\"" }] }]
  }
}
EOF
    printf -- '---\nname: build-app\ndescription: test\n---\n' > .claude/skills/build-app/SKILL.md
    mkdir -p .claude/skills/fix-bug .claude/skills/add-feature .claude/scripts
    printf -- '---\nname: fix-bug\ndescription: test\n---\n' > .claude/skills/fix-bug/SKILL.md
    printf -- '---\nname: add-feature\ndescription: test\n---\n' > .claude/skills/add-feature/SKILL.md
    cp "$VERIFY" .claude/scripts/verify-spec.sh
    printf -- '---\nname: tier-reviewer\ndescription: test\n---\n' > .claude/agents/tier-reviewer.md
    mkdir -p .claude/hooks
    printf '#!/usr/bin/env bash\necho "État du projet"\n' > .claude/hooks/session-start.sh
    printf '#!/usr/bin/env bash\nexit 0\n' > .claude/hooks/guard-tests.sh
    git init -q -b main
  )
}

# add_design <dossier> : ajoute les maquettes de l'exemple et docs/12.
add_design() {
  local p=$1
  cp -R "$IP/examples/maquettes-canettes" "$p/design"
  rm -rf "$p/design/captures"
  printf '# 12 — Maquettes\n\n| ECR-01 | Connexion | F-01 |\n| ECR-02 | Tableau de bord | F-03 |\n' > "$p/docs/12-maquettes.md"
}

# raw_templates <dossier> : modèles copiés tels quels, sans remplissage.
raw_templates() {
  local p=$1 t="$IP/templates"
  rm -rf "$p"
  mkdir -p "$p/docs/adr" "$p/.claude/skills/build-app" "$p/.claude/agents"
  cp "$t/CLAUDE.md" "$t/PLAN.md" "$p/"
  cp "$t/gitignore" "$p/.gitignore"
  cp "$t/env.example" "$p/.env.example"
  cp "$t"/docs/*.md "$p/docs/"
  rm "$p/docs/12-maquettes.md"
  cp "$t/claude/settings.json" "$p/.claude/"
  cp "$t/claude/skills/build-app/SKILL.md" "$p/.claude/skills/build-app/"
  cp -R "$t/claude/skills/fix-bug" "$t/claude/skills/add-feature" "$p/.claude/skills/"
  mkdir -p "$p/.claude/scripts" && cp "$VERIFY" "$p/.claude/scripts/verify-spec.sh"
  cp "$t/claude/agents/tier-reviewer.md" "$p/.claude/agents/"
  cp -R "$t/claude/hooks" "$p/.claude/hooks"
  (cd "$p" && git init -q -b main)
}
