# 🔁 Git Remote Updater (CLI)

Herramienta en Bash para actualizar automáticamente los remotos (origin) de múltiples repositorios Git, sustituyendo un usuario antiguo por uno nuevo en las URLs.

Pensado para escenarios como:

Cambio de username en GitHub
Migración de repos entre cuentas
Transferencias de proyectos 

## ¿Qué hace?

El script:

🔍 Escanea recursivamente el directorio actual en busca de repositorios (.git)

🚫 Ignora carpetas comunes de dependencias:

	- node_modules

	- venv

	- .venv

	- vendor

🔗 Detecta si cada repo tiene remoto origin

🔄 Sustituye el usuario antiguo por el nuevo en la URL

✅ Aplica el cambio automáticamente (o lo simula)

⚠️ Qué NO hace

❌ No cambia el autor de los commits

❌ No modifica el historial

❌ No crea repositorios en GitHub

❌ No cambia permisos ni ownership en remoto

👉 Solo actualiza la URL del remoto en tu entorno local.

## Uso

### Modo simulación (recomendado)

Antes de hacer cambios reales:

./script.sh --old usuario-viejo --new usuario-nuevo --dry-run

Esto mostrará qué repos serían modificados sin tocar nada.

### Ejecución real

./script.sh --old usuario-viejo --new usuario-nuevo

## Opciones disponibles 🛠️

Opción	Descripción
--old	Usuario actual en las URLs (obligatorio)
--new	Nuevo usuario destino (obligatorio)
--dry-run	Simula los cambios sin aplicarlos
--help	Muestra ayuda

### Ejemplo práctico

Antes:

git@github.com:usuario-viejo/proyecto.git

Después:

git@github.com:usuario-nuevo/proyecto.git

## Ejecución

Dar permisos:
```
chmod +x script.sh
```

Ejecutar desde la carpeta donde tengas tus repos:
```
./script.sh --old <usuario_antiguo> --new <usuario_nuevo>
```
### Buenas prácticas

- Usa siempre primero --dry-run
- Prueba en una carpeta pequeña antes de ejecutar globalmente
- Revisa algunos repos manualmente tras el cambio
- Asegúrate de que los repos existen en el nuevo usuario

## Compatibilidad

Soporta URLs tipo:

git@github.com:user/repo.git
https://github.com/user/repo.git

## Detalles técnicos
- Usa find para descubrir repositorios
- Usa sed para reemplazo seguro del usuario
- Incluye control de errores (set -euo pipefail)
- Evita modificar dependencias comunes

## Resumen

Una herramienta simple, rápida y segura para migrar remotos Git en masa sin tener que ir repositorio por repositorio.

## Licencia

MIT. Uso libre. Modifícalo, rómpelo o mejóralo 
