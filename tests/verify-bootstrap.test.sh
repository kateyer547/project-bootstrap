#!/usr/bin/env bash
# Tests de skills/init-project/scripts/verify-bootstrap.sh sur des faux projets.
. "$(dirname "$0")/lib/assert.sh"
. "$(dirname "$0")/lib/mkproj.sh"

echo "== verify-bootstrap.sh"

P="$TMP/projet"
run() { bash "$VERIFY" "$P"; }

# Commandes utilisées par le script, pour simuler un poste sans node, python ni jq.
BASE_CMDS=(grep sed awk sort find head tr wc comm dirname basename)

mkproj "$P"
expect "projet valide" 0 "Cadrage complet" "hors MVP.*F-02" -- run

mkproj "$P"; printf '{"permissions": {,}\n' > "$P/.claude/settings.json"
expect "JSON invalide" 1 "n'est pas un JSON valide" -- run

mkproj "$P"; restricted_bin "$TMP/bin-sans-json" "${BASE_CMDS[@]}" git
expect "aucun outil JSON : simple information" 0 "non vérifié : ni node, ni python, ni jq" -- \
  env PATH="$TMP/bin-sans-json" "$BASH" "$VERIFY" "$P"

restricted_bin "$TMP/bin-sans-git" "${BASE_CMDS[@]}"
expect "git absent" 1 "git introuvable" -- env PATH="$TMP/bin-sans-git" "$BASH" "$VERIFY" "$P"

mkproj "$P"; rm -rf "$P/.git"
expect "dossier hors dépôt git" 1 "n'est pas un dépôt git" -- run

mkproj "$P"; printf '.env*\n' > "$P/.gitignore"
expect ".gitignore qui exclut .env.example" 1 "\.env\.example est ignoré" -- run

mkproj "$P"; printf 'node_modules/\n' > "$P/.gitignore"; printf 'X=1\n' > "$P/.env"; (cd "$P" && git add -f .env 2>/dev/null)
expect ".env versionné" 1 "\.env n'est pas ignoré" -- run

mkproj "$P"; rm "$P/.gitignore"
expect ".gitignore absent" 1 "\.gitignore manquant" -- run

mkproj "$P"; rm "$P/docs/07-securite.md"
expect "document manquant" 1 "docs/07-securite.md manquant" -- run

mkproj "$P"; for f in "$P"/docs/*.md; do edit_file "$f" 's/$/\r/'; done
expect "fichiers en fins de ligne Windows (CRLF)" 0 "Cadrage complet" -- run

raw_templates "$P"
expect "modèles non remplis" 1 "marqueurs \{\{\.\.\.\}\} restants" "commentaires d'aide" -- run

mkproj "$P"; edit_file "$P/docs/05-modele-donnees.md" 's/erDiagram/flowchart/'
expect "diagramme erDiagram absent" 1 "pas de diagramme Mermaid erDiagram" -- run

mkproj "$P"; edit_file "$P/docs/11-paliers.md" 's/F-01 F-03/F-01/'
expect "fonctionnalité MVP absente des paliers" 1 "fonctionnalités MVP absentes .*F-03" -- run

mkproj "$P"; edit_file "$P/docs/02-specifications-fonctionnelles.md" 's/Priorité :\*\* V2/Priorité :** Indispensable/'
expect "priorité inattendue comptée comme MVP" 1 "fonctionnalités MVP absentes .*F-02" -- run

mkproj "$P"; edit_file "$P/docs/02-specifications-fonctionnelles.md" 's/Priorité :\*\* V2/Priorité :** Plus tard/'
expect "priorité « Plus tard » non exigée" 0 "hors MVP.*F-02" -- run

mkproj "$P"; edit_file "$P/docs/11-paliers.md" 's/ENF-01//'
expect "exigence non fonctionnelle absente des paliers" 1 "exigences non fonctionnelles absentes .*ENF-01" -- run

mkproj "$P"; edit_file "$P/docs/11-paliers.md" 's/F-01 F-03/F-01 F-03 F-09 ENF-07/'
expect "identifiants inconnus dans les paliers" 1 "absents de docs/02.*ENF-07 F-09" -- run

mkproj "$P"; printf '\n## Palier 2 — Vide\n\n- Rien à valider\n' >> "$P/docs/11-paliers.md"
expect "palier sans commande de validation" 1 "paliers sans bloc de commandes" "Palier 2 — Vide" -- run

mkproj "$P"; printf 'API_KEY=sk_live_4f8a9b2c7d1e\n' >> "$P/.env.example"
expect "secret en clair" 1 "ressemblant à des secrets" -- run

mkproj "$P"; add_design "$P"
expect "maquettes valides (exemple du plugin)" 0 "écran\(s\) déclaré\(s\), tous présents" "tous les liens entre écrans aboutissent" -- run

mkproj "$P"; add_design "$P"; printf '<a href="ecr-99.html">Suite</a>\n' >> "$P/design/ecrans/ecr-01.html"
expect "lien cassé entre écrans" 1 "liens cassés .*ecr-99\.html" -- run

mkproj "$P"; add_design "$P"; rm "$P/design/ecrans/ecr-05.html"
expect "écran déclaré mais absent" 1 "écrans déclarés mais absents .*ecr-05\.html" -- run

mkproj "$P"; add_design "$P"; cp "$IP/templates/design/ecrans/_modele.html" "$P/design/ecrans/"
expect "modèle d'écran copié dans le projet" 1 "_modele\.html ne doit pas" -- run

summary
