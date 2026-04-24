#!/bin/bash

OLD_USER="sapoclay"
NEW_USER="entreunosyceros"

echo "🚀 Iniciando escaneo inteligente de repositorios..."
echo "Ignorando: node_modules, venv, .venv, vendor..."
echo "------------------------------------------------"

# Buscamos carpetas .git pero EXCLUYENDO carpetas de dependencias comunes
find . -type d \( -name "node_modules" -o -name "venv" -o -name ".venv" -o -name "vendor" \) -prune -o -name ".git" -type d -print | while read -r gitdir; do
    
    # La carpeta del proyecto es la que contiene a .git
    proj_dir=$(dirname "$gitdir")
    
    # Entramos en la carpeta
    cd "$proj_dir" || continue

    # Obtenemos el remoto actual
    OLD_URL=$(git remote get-url origin 2>/dev/null)

    # Si el remoto existe y contiene tu usuario viejo
    if [[ "$OLD_URL" == *"$OLD_USER"* ]]; then
        NEW_URL="${OLD_URL//$OLD_USER/$NEW_USER}"
        
        # Realizamos el cambio
        git remote set-url origin "$NEW_URL"
        
        echo "✅ ACTUALIZADO: $proj_dir"
        echo "   -> $NEW_URL"
    else
        # Esto ayuda a saber que el script está trabajando sin tocar lo que no debe
        echo "⏩ SALTADO: $proj_dir (Ya actualizado o es de otro autor)"
    fi

    # Volvemos a la base
    cd - > /dev/null
done

echo "------------------------------------------------"
echo "✨ ¡Proceso completado con éxito!"