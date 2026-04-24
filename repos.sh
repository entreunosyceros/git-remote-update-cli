#!/bin/bash

set -euo pipefail

# -----------------------------
# Opciones por defecto a configurar
# -----------------------------
OLD_USER=""
NEW_USER=""
DRY_RUN=false

# -----------------------------
# Ayuda

usage() {
    echo "Uso: $0 --old <usuario_antiguo> --new <usuario_nuevo> [--dry-run]"
    echo ""
    echo "Opciones:"
    echo "  --old       Usuario antiguo (obligatorio)"
    echo "  --new       Usuario nuevo (obligatorio)"
    echo "  --dry-run   Simula cambios sin aplicarlos"
    echo "  --help      Muestra esta ayuda"
    exit 1
}

# -----------------------------
# Pasar argumentos

while [[ $# -gt 0 ]]; do
    case "$1" in
        --old)
            OLD_USER="$2"
            shift 2
            ;;
        --new)
            NEW_USER="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help)
            usage
            ;;
        *)
            echo "❌ Opción desconocida: $1"
            usage
            ;;
    esac
done

# Validación
if [[ -z "$OLD_USER" || -z "$NEW_USER" ]]; then
    echo "❌ Debes especificar --old y --new"
    usage
fi

# -----------------------------
# Inicio

echo "🔍 Escaneando repositorios..."
echo "Old user: $OLD_USER"
echo "New user: $NEW_USER"
echo "Dry run:  $DRY_RUN"
echo "Ignorando: node_modules, venv, .venv, vendor..."
echo "------------------------------------------------"

find . -type d \( -name "node_modules" -o -name "venv" -o -name ".venv" -o -name "vendor" \) -prune -o -name ".git" -type d -print | while read -r gitdir; do
    
    proj_dir=$(dirname "$gitdir")
    pushd "$proj_dir" > /dev/null || continue

    if ! git remote get-url origin &>/dev/null; then
        echo "⚠️ SIN REMOTO: $proj_dir"
        popd > /dev/null
        continue
    fi

    OLD_URL=$(git remote get-url origin)

    if [[ "$OLD_URL" == *"$OLD_USER"* ]]; then
        
        NEW_URL=$(echo "$OLD_URL" | sed "s#\(github.com[:/]\)$OLD_USER/#\1$NEW_USER/#")

        echo "🔁 $proj_dir"
        echo "   OLD: $OLD_URL"
        echo "   NEW: $NEW_URL"

        if [[ "$DRY_RUN" == true ]]; then
            echo "🧪 SIMULACIÓN: git remote set-url origin $NEW_URL"
        else
            git remote set-url origin "$NEW_URL"
            echo "✅ ACTUALIZADO"
        fi

    else
        echo "⏩ SALTADO: $proj_dir"
    fi

    popd > /dev/null

done

echo "------------------------------------------------"
echo "✨🥳 Proceso completado 🎉🎉"