#!/usr/bin/env bash
# Hook PostToolUse (Edit|Write|MultiEdit) de {{NOM_PROJET}} : formate uniquement le fichier
# qui vient d'être modifié. Ne bloque jamais : un échec de formatage est signalé par check.

# Extensions formatées, séparées par des espaces (sans point).
EXTENSIONS='{{EXTENSIONS_FORMATEES}}'
# Formate le fichier reçu en argument : commande « Formater un seul fichier » du contrat d'outillage de docs/03.
formater() { {{CMD_FORMAT_FICHIER}} "$1"; }
# AIDE : le chemin du fichier est ajouté à la fin. Exemples : `npx prettier --write`, `dotnet format whitespace --include`, `ruff format`.
# AIDE : utilise un outil installé par le projet (ou une cible du lanceur qui accepte un fichier), pas un outil global.

input=$(cat)
file=$(printf '%s' "$input" | tr -d '\n' | sed -n -E 's/.*"file_path"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p' | sed -e 's/\\\\/\//g' -e 's/\\\//\//g')
[ -n "$file" ] && [ -f "$file" ] || exit 0

ext=${file##*.}
case " $EXTENSIONS " in
  *" $ext "*) ;;
  *) exit 0 ;;
esac

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || true
formater "$file" >/dev/null 2>&1 || echo "format-file.sh : le formatage de $file a échoué (check le signalera)" >&2
exit 0
