#!/usr/bin/env bash
# Hook PreToolUse (Edit|Write|MultiEdit) de {{NOM_PROJET}} : refuse l'ajout d'un marqueur
# qui exclut ou isole un test (skip, only, ignore…). Code 2 = action bloquée, le message
# d'erreur est transmis à Claude. Lit le JSON de l'outil sur l'entrée standard, sans jq.

# Chemins des fichiers de test : motifs bash sur le chemin absolu écrit avec des « / », séparés par des espaces.
MOTIFS_TEST='{{MOTIFS_TEST_HOOK}}'
# Marqueurs interdits : une expression régulière étendue.
MARQUEURS='{{MARQUEURS_SKIP_HOOK}}'
# AIDE : reprends le contrat d'outillage de docs/03. Bases multi-frameworks à adapter à la stack :
# AIDE : MOTIFS_TEST='*/tests/* */test/* */__tests__/* *.test.* *.spec.* *_test.* */test_*.py *Tests.cs *Test.java *Test.php'
# AIDE : MARQUEURS='\.(skip|only)\(|\b(xit|xdescribe|xtest|fit|fdescribe)\(|#\[ignore\]|Skip *=|\[Ignore|@Disabled|@Ignore|pytest\.mark\.(skip|xfail)|unittest\.skip|markTestSkipped|markTestIncomplete|t\.Skip\('

input=$(cat)

# Chemin du fichier visé : JSON déséchappé, séparateurs Windows convertis en « / ».
file=$(printf '%s' "$input" | tr -d '\n' | sed -n -E 's/.*"file_path"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p' | sed -e 's/\\\\/\//g' -e 's/\\\//\//g')
[ -n "$file" ] || exit 0

set -f
is_test=0
for motif in $MOTIFS_TEST; do
  # shellcheck disable=SC2254
  case "$file" in $motif) is_test=1; break ;; esac
done
set +f
[ "$is_test" -eq 1 ] || exit 0

# Valeurs JSON d'un champ (toutes ses occurrences, MultiEdit en a plusieurs). Les \n, \t, \r
# échappés deviennent des espaces : sinon « \nxdescribe( » ne commence pas un mot pour \b.
champ() { printf '%s' "$input" | tr -d '\n' | grep -o -E "\"$1\"[[:space:]]*:[[:space:]]*\"([^\"\\\\]|\\\\.)*\"" | sed -E 's/\\[nrt]/ /g'; }
compte() { grep -o -E "$MARQUEURS" | wc -l | tr -d ' '; }

nouveau=$( { champ content; champ new_string; } | compte)
if printf '%s' "$input" | grep -q -E '"old_string"'; then
  ancien=$(champ old_string | compte)
else
  # Write : on compare avec le fichier tel qu'il existe avant l'écriture.
  disque=$file
  command -v cygpath >/dev/null 2>&1 && disque=$(cygpath -u "$file" 2>/dev/null || printf '%s' "$file")
  ancien=0
  [ -f "$disque" ] && ancien=$(compte < "$disque")
fi

if [ "${nouveau:-0}" -gt "${ancien:-0}" ]; then
  exemple=$( { champ content; champ new_string; } | grep -o -E "$MARQUEURS" | head -1)
  {
    echo "Bloqué par .claude/hooks/guard-tests.sh : ajout du marqueur « $exemple » dans le test $file."
    echo "Ne désactive et n'isole jamais un test pour faire passer une validation : corrige le code."
    echo "Si le test te semble faux, consigne un blocage dans PLAN.md et demande à l'utilisateur."
  } >&2
  exit 2
fi
exit 0
