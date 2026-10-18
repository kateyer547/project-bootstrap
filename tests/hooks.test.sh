#!/usr/bin/env bash
# Tests des hooks de templates/claude/hooks/, instanciés avec les valeurs par défaut de leurs lignes AIDE.
. "$(dirname "$0")/lib/assert.sh"

echo "== Hooks Claude Code"

SRC="$IP/templates/claude/hooks"
H="$TMP/hooks"
mkdir -p "$H"

# guard-tests.sh avec les motifs et marqueurs par défaut documentés dans ses lignes AIDE.
awk '
  /^(MOTIFS_TEST|MARQUEURS)=/ { next }
  /^# AIDE : (MOTIFS_TEST|MARQUEURS)=/ { sub(/^# AIDE : /, ""); print; next }
  /^# AIDE :/ { next }
  { gsub(/\{\{NOM_PROJET\}\}/, "test"); print }
' "$SRC/guard-tests.sh" > "$H/guard-tests.sh"
# format-file.sh dont le « formatage » vide le fichier, pour l'observer.
sed -e "s/{{EXTENSIONS_FORMATEES}}/ts js/" -e 's/{{CMD_FORMAT_FICHIER}}/cp \/dev\/null/' -e 's/{{NOM_PROJET}}/test/' -e '/^# AIDE :/d' \
  "$SRC/format-file.sh" > "$H/format-file.sh"
sed -e 's/{{NOM_PROJET}}/test/' "$SRC/session-start.sh" > "$H/session-start.sh"

for f in "$H"/*.sh; do
  if grep -q -E '\{\{|AIDE :' "$f"; then ko_case "instanciation de $(basename "$f")" "marqueur ou AIDE restant"; fi
done

# hook <script> <json> : envoie le JSON sur l'entrée standard du hook.
hook() { printf '%s' "$2" | bash "$H/$1"; }

# --- guard-tests.sh
G=guard-tests.sh
expect "Write d'un test avec .skip( : bloqué" 2 "Bloqué par .claude/hooks/guard-tests.sh" "\.skip\(" -- \
  hook $G '{"tool_name":"Write","tool_input":{"file_path":"/p/tests/panier.test.ts","content":"it.skip(\"calcule\", () => {})"}}'
expect "Write d'un fichier de code avec .skip( : autorisé" 0 -- \
  hook $G '{"tool_name":"Write","tool_input":{"file_path":"/p/src/panier.ts","content":"liste.skip(2)"}}'
expect "Edit qui ajoute .only( : bloqué" 2 "\.only\(" -- \
  hook $G '{"tool_name":"Edit","tool_input":{"file_path":"/p/src/panier.spec.js","old_string":"it(\"a\"","new_string":"it.only(\"a\""}}'
expect "Edit qui garde un .skip( existant : autorisé" 0 -- \
  hook $G '{"tool_name":"Edit","tool_input":{"file_path":"/p/tests/a.test.ts","old_string":"it.skip(\"a\", f)","new_string":"it.skip(\"a\", g)"}}'
expect "Edit qui retire un .skip( : autorisé" 0 -- \
  hook $G '{"tool_name":"Edit","tool_input":{"file_path":"/p/tests/a.test.ts","old_string":"it.skip(\"a\"","new_string":"it(\"a\""}}'
expect "chemin Windows et #[ignore] Rust : bloqué" 2 "#\[ignore\]" -- \
  hook $G '{"tool_name":"Write","tool_input":{"file_path":"C:\\projet\\tests\\stock_test.rs","content":"#[ignore]\nfn t() {}"}}'
expect "pytest.mark.skip : bloqué" 2 -- \
  hook $G '{"tool_name":"Write","tool_input":{"file_path":"/p/tests/test_stock.py","content":"@pytest.mark.skip\ndef test_a(): pass"}}'
expect "xUnit [Fact(Skip = ...)] : bloqué" 2 -- \
  hook $G '{"tool_name":"Edit","tool_input":{"file_path":"/p/src/Stock.Tests/StockTests.cs","old_string":"[Fact]","new_string":"[Fact(Skip = \"plus tard\")]"}}'
expect "JSON sur plusieurs lignes : bloqué" 2 -- \
  hook $G "$(printf '{\n  "tool_name": "Write",\n  "tool_input": {\n    "file_path": "/p/tests/a.test.ts",\n    "content": "xit(\\"a\\")"\n  }\n}')"
expect "MultiEdit avec un .skip( ajouté : bloqué" 2 -- \
  hook $G '{"tool_name":"MultiEdit","tool_input":{"file_path":"/p/tests/a.test.ts","edits":[{"old_string":"a","new_string":"b"},{"old_string":"it(","new_string":"it.skip("}]}}'
expect "test sans marqueur, guillemets échappés : autorisé" 0 -- \
  hook $G '{"tool_name":"Write","tool_input":{"file_path":"/p/tests/a.test.ts","content":"it(\"dit \\\"bonjour\\\"\", () => {\n  expect(1).toBe(1)\n})"}}'
expect "entrée sans file_path : ignorée" 0 -- hook $G '{"tool_name":"Bash","tool_input":{"command":"ls"}}'

existant="$TMP/tests/existant.test.ts"
mkdir -p "$TMP/tests"; printf 'it.skip("ancien", f)\n' > "$existant"
expect "Write qui garde le .skip( du fichier existant : autorisé" 0 -- \
  hook $G "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$existant\",\"content\":\"it.skip(\\\"ancien\\\", g)\"}}"
expect "Write qui ajoute un 2e .skip( au fichier existant : bloqué" 2 -- \
  hook $G "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$existant\",\"content\":\"it.skip(\\\"ancien\\\", g)\nit.skip(\\\"nouveau\\\", h)\"}}"

# --- format-file.sh
F=format-file.sh
printf 'contenu\n' > "$TMP/a.ts"; printf 'contenu\n' > "$TMP/a.md"
hook $F "{\"tool_name\":\"Edit\",\"tool_input\":{\"file_path\":\"$TMP/a.ts\"}}" >/dev/null 2>&1
if [ ! -s "$TMP/a.ts" ]; then ok_case "format-file : extension listée formatée"; else ko_case "format-file : extension listée formatée" "a.ts non traité"; fi
hook $F "{\"tool_name\":\"Edit\",\"tool_input\":{\"file_path\":\"$TMP/a.md\"}}" >/dev/null 2>&1
if [ -s "$TMP/a.md" ]; then ok_case "format-file : autre extension ignorée"; else ko_case "format-file : autre extension ignorée" "a.md modifié"; fi
expect "format-file : fichier absent sans erreur" 0 -- hook $F '{"tool_name":"Write","tool_input":{"file_path":"/inexistant/x.ts"}}'

# --- session-start.sh
P="$TMP/projet"
mkdir -p "$P"
cat > "$P/PLAN.md" <<'EOF'
# Plan de réalisation

## Paliers

- [x] **Palier 1 — Socle**
- [ ] **Palier 2 — Données** (point d'arrêt)
- [ ] **Palier 3 — Sécurité**

## Blocages

<!-- AIDE : laisse cette section vide ;
     build-app y consigne les blocages. -->

## Journal
EOF
(
  cd "$P" && git init -q -b main && git add PLAN.md \
    && git -c user.name=t -c user.email=t@t commit -q -m "docs: cadrage" && git tag tier-0 \
    && git -c user.name=t -c user.email=t@t commit -q --allow-empty -m "chore(tier-1): palier validé"
)
start() { CLAUDE_PROJECT_DIR="$P" bash "$H/session-start.sh"; }
expect "session-start : palier courant et palier en attente de fusion" 0 \
  "Palier courant : Palier 2 — Données \(point d'arrêt\)" "Aucun blocage" "en attente de fusion : 1" "dernier tag de palier : tier-0" -- start
(cd "$P" && git tag tier-1)
expect "session-start : plus d'attente une fois le tag posé" 0 "!en attente de fusion" "dernier tag de palier : tier-1" -- start
printf '\n## Blocages\n\n- `just check` échoue sur la migration 3 : quelle stratégie ?\n' >> "$P/PLAN.md"
edit_file "$P/PLAN.md" '/^## Journal/d'
expect "session-start : blocage ouvert signalé" 0 "BLOCAGE ouvert" -- start
expect "session-start : sans PLAN.md, rien n'est affiché" 0 "!État du projet" -- env CLAUDE_PROJECT_DIR="$TMP/vide" bash "$H/session-start.sh"

summary
