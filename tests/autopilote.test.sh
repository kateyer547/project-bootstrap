#!/usr/bin/env bash
# Tests de templates/claude/scripts/autopilote.sh avec un faux CLI claude.
. "$(dirname "$0")/lib/assert.sh"

echo "== Autopilote"

A="$TMP/autopilote.sh"
sed -e 's/{{NOM_PROJET}}/test/' "$IP/templates/claude/scripts/autopilote.sh" > "$A"
if grep -q -E '\{\{|AIDE :' "$A"; then ko_case "instanciation d'autopilote.sh" "marqueur ou AIDE restant"; fi

GIT=(git -c user.name=t -c user.email=t@t)

# Faux claude : selon FAUX_MODE, coche le premier palier et commite (avance),
# consigne un blocage (bloque), clôture un palier sans tag (arret), ne fait rien (rien) ou échoue (erreur).
FAUX="$TMP/faux-claude"
cat > "$FAUX" <<'EOF'
#!/usr/bin/env bash
case "$*" in *"mode autopilote"*"--permission-mode acceptEdits"*) ;; *) echo "arguments inattendus : $*"; exit 3 ;; esac
g() { git -c user.name=t -c user.email=t@t "$@"; }
n=$(grep -m 1 -n -E '^- \[ \] \*\*Palier' PLAN.md | cut -d: -f1)
num=$(sed -n "${n}p" PLAN.md | sed -E 's/.*Palier ([0-9]+).*/\1/')
case "$FAUX_MODE" in
  avance)
    sed "${n}s/- \[ \]/- [x]/" PLAN.md > PLAN.tmp && mv PLAN.tmp PLAN.md
    g commit -q -am "chore(tier-$num): palier validé" && g tag "tier-$num"
    echo "Palier $num terminé." ;;
  bloque)
    awk '/^## Blocages/ { print; getline; print; print "- just check échoue : quelle option ?"; next } { print }' PLAN.md > PLAN.tmp && mv PLAN.tmp PLAN.md
    g commit -q -am "docs(plan): blocage" ;;
  arret)
    sed "${n}s/- \[ \]/- [x]/" PLAN.md > PLAN.tmp && mv PLAN.tmp PLAN.md
    g commit -q -am "chore(tier-$num): palier validé" ;;
  rien) echo "Rien à faire." ;;
  erreur) echo "Erreur d'API" ; exit 1 ;;
esac
EOF
chmod +x "$FAUX"

# projet <paliers non cochés> : dépôt avec PLAN.md et N paliers à faire.
P="$TMP/projet"
projet() {
  rm -rf "$P"; mkdir -p "$P"
  {
    printf '# Plan\n\n## Paliers\n\n- [x] **Palier 1 — Socle**\n'
    for i in $(seq 2 $((1 + $1))); do printf -- '- [ ] **Palier %s — Lot %s**\n' "$i" "$i"; done
    printf '\n## Blocages\n\n<!-- AIDE : vide. -->\n\n## Décisions à confirmer\n\n## Journal\n'
  } > "$P/PLAN.md"
  (cd "$P" && git init -q -b main && "${GIT[@]}" add PLAN.md && "${GIT[@]}" commit -q -m init && git tag tier-1)
}
auto() { (cd "$P" && CLAUDE_BIN="$FAUX" FAUX_MODE="$1" bash "$A" "${2:-20}"); }

projet 3
expect "enchaîne les sessions jusqu'au dernier palier" 0 "Session 1/20 : Palier 2" "Session 3/20 : Palier 4" "Terminé : tous les paliers" -- auto avance
[ -d "$P/.autopilote" ] && [ "$(find "$P/.autopilote" -name 'session-*.log' | wc -l)" -eq 3 ] \
  && ok_case "un journal par session dans .autopilote/" || ko_case "un journal par session dans .autopilote/" "$(ls "$P/.autopilote" 2>&1)"

projet 0
expect "rien à faire : aucune session lancée" 0 "Terminé" "!Session" -- auto avance

projet 3
expect "limite du nombre de sessions" 0 "Session 2/2" "2 sessions atteintes" -- auto avance 2

projet 2
expect "blocage consigné : arrêt" 1 "Session 1/20" "blocage ouvert" "!Session 2/20" -- auto bloque

projet 2
expect "point d'arrêt (palier validé sans tag) : rend la main" 0 "Session 1/20" "palier\(s\) 2 validé\(s\)" "!Session 2/20" -- auto arret

projet 2
expect "session sans commit : arrêt" 1 "aucun commit" -- auto rien

projet 2
expect "session en erreur : arrêt" 1 "terminée en erreur \(code 1\)" -- auto erreur

rm -f "$P/PLAN.md"
expect "sans PLAN.md : refus" 2 "PLAN.md introuvable" -- auto avance

projet 1
expect "CLI claude introuvable : refus" 2 "Commande introuvable" -- \
  bash -c 'cd "$1" && CLAUDE_BIN=claude-inexistant bash "$2"' _ "$P" "$A"

summary
