#!/bin/bash

set -euo pipefail

OLD_USER=""
NEW_USER=""
DRY_RUN=false
AUTO_YES=false

usage() {
    echo "Uso: $0 --old <usuario_antiguo> --new <usuario_nuevo> [--dry-run]"
    exit 1
}

# -----------------------------
# Args
# -----------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --old) OLD_USER="$2"; shift 2 ;;
        --new) NEW_USER="$2"; shift 2 ;;
        --dry-run) DRY_RUN=true; shift ;;
        --help) usage ;;
        *) echo "Opción desconocida: $1"; usage ;;
    esac
done

if [[ -z "$OLD_USER" || -z "$NEW_USER" ]]; then
    usage
fi

echo "🔍 Escaneando repositorios..."
echo "Old: $OLD_USER | New: $NEW_USER | Dry-run: $DRY_RUN"
echo "------------------------------------------------"

find . -type d \( -name "node_modules" -o -name "venv" -o -name ".venv" -o -name "vendor" \) -prune -o -name ".git" -type d -print | while read -r gitdir; do
    
    proj_dir=$(dirname "$gitdir")
    pushd "$proj_dir" > /dev/null || continue

    if ! git remote get-url origin &>/dev/null; then
        popd > /dev/null
        continue
    fi

    OLD_URL=$(git remote get-url origin)

    if [[ "$OLD_URL" == *"$OLD_USER"* ]]; then
        
        NEW_URL=$(echo "$OLD_URL" | sed "s#\(github.com[:/]\)$OLD_USER/#\1$NEW_USER/#")

        echo ""
        echo "📁 $proj_dir"
        echo "   OLD: $OLD_URL"
        echo "   NEW: $NEW_URL"

        if [[ "$AUTO_YES" == true ]]; then
            choice="y"
        else
            read -p "👉 ¿Aplicar cambio? [y]es / [n]o / [a]ll / [q]uit: " choice
        fi

        case "$choice" in
            y|Y)
                if [[ "$DRY_RUN" == true ]]; then
                    echo "🧪 SIMULACIÓN: cambio aplicado"
                else
                    git remote set-url origin "$NEW_URL"
                    echo "✅ ACTUALIZADO"
                fi
                ;;
            a|A)
                AUTO_YES=true
                if [[ "$DRY_RUN" == true ]]; then
                    echo "🧪 SIMULACIÓN: cambio aplicado (auto)"
                else
                    git remote set-url origin "$NEW_URL"
                    echo "✅ ACTUALIZADO (auto)"
                fi
                ;;
            q|Q)
                echo "⛔ Abortado por el usuario"
                popd > /dev/null
                exit 0
                ;;
            *)
                echo "⏩ Saltado"
                ;;
        esac
    fi

    popd > /dev/null

done

echo "------------------------------------------------"
echo "✨ Proceso finalizado"