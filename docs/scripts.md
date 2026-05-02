# 📜 Scripts

Los scripts personalizados se encuentran en `~/.dotfiles/scripts/` y se enlazan simbólicamente a `~/.local/bin/` durante la instalación, lo que los hace disponibles como comandos normales desde cualquier lugar.

---

## `up` — Actualizador Completo del Sistema

**Ubicación:** `~/.dotfiles/bin/.local/bin/up`  
**Enlace simbólico en:** `~/.local/bin/up`

Ejecuta una actualización completa del sistema con un solo comando:

```bash
up
```

### Qué actualiza

| Paso | Comando | Qué hace |
|------|---------|----------|
| 1 | `apt-get update && upgrade` | Paquetes del sistema Ubuntu/Debian |
| 2 | `apt-get autoremove` | Elimina paquetes no utilizados |
| 3 | `flatpak update` | Todas las aplicaciones Flatpak (incluido WezTerm) |
| 4 | `nix profile upgrade '.*'` | Todas las herramientas CLI instaladas con Nix |
| 5 | `nix store gc` | Recoge basura en el almacén Nix (libera espacio en disco) |
| 6 | `git pull` en cada directorio de plugin | Actualiza los plugins de Zsh (autosuggestions, syntax-highlighting) |

### Actualizaciones parciales

```bash
# Actualizar solo los paquetes Nix
nix profile upgrade '.*'

# Actualizar un paquete Nix específico
nix profile upgrade nixpkgs#bat

# Actualizar solo las aplicaciones Flatpak
flatpak update

# Limpiar solo el almacén Nix
nix store gc

# Actualizar solo los plugins de Zsh
git -C ~/.zsh/plugins/zsh-autosuggestions pull --ff-only
git -C ~/.zsh/plugins/zsh-syntax-highlighting pull --ff-only
```

---

## `theme-switcher` — Gestor de Temas

**Ubicación:** `~/.dotfiles/scripts/theme-switcher`  
**Enlace simbólico en:** `~/.local/bin/theme-switcher`

Cambia el esquema de colores de WezTerm, bat y Starship simultáneamente.

```bash
theme-switcher catppuccin      # pasteles cálidos (por defecto)
theme-switcher tokyo-night     # azules y morados oscuros
theme-switcher dracula         # alto contraste rosa/morado

# Sin argumento — abre un menu interactivo (flechas + Enter):
theme-switcher
```

### Qué se modifica

| Componente | Archivo modificado |
|------------|--------------------|
| WezTerm | `~/.config/current-theme` (leído al iniciar / recarga en directo vía SIGUSR1) |
| bat | Línea `--theme=` en `~/.config/bat/config` |
| Starship | Línea `palette =` en `~/.config/starship.toml` |
| Fondo GNOME | vía `gsettings` (solo si existe una imagen en `~/.local/share/wallpapers/`) |

Consulta `docs/themes.md` para más detalles sobre cómo añadir nuevos temas.

---

## `docs` — Navegador de Documentación

**Ubicación:** `~/.dotfiles/scripts/docs`  
**Enlace simbólico en:** `~/.local/bin/docs`  
**Alias:** `docs` (también definido en `~/.zshrc`)

Abre el navegador de documentación interactivo en la terminal usando `glow`.

Sin argumentos abre un menu interactivo con cursor (flechas ↑ ↓ y Enter).

```bash
docs                     # abrir el navegador de documentación interactivo
docs tools               # abrir directamente la referencia de herramientas
docs wezterm             # abrir directamente la documentación de WezTerm
docs zsh                 # abrir directamente la documentación de Zsh
docs themes              # abrir la documentación del sistema de temas
docs scripts             # abrir este archivo
docs stow                # abrir la guía de GNU Stow
docs troubleshooting     # abrir la guía de solución de problemas
```

### Dentro del navegador de documentación

| Tecla | Acción |
|-------|--------|
| ↑ ↓ | Navegar por archivos |
| `Enter` | Abrir documento seleccionado |
| `Esc` | Volver a la lista de archivos |
| `/` | Buscar dentro del documento |
| `q` | Salir |

---

## `plantuml-render` — Gestor del Render de PlantUML

**Ubicación:** `~/.dotfiles/scripts/plantuml-render`  
**Enlace simbólico en:** `~/.local/bin/plantuml-render`

Levanta y gestiona un contenedor de PlantUML Server con Podman para renderizar diagramas.

El script abre un menu interactivo con cursor (flechas ↑ ↓ y Enter).

```bash
plantuml-render
```

### Qué hace

| Opción | Acción |
|--------|--------|
| `1) Arrancar` | Crea el contenedor si no existe o lo arranca si está detenido |
| `2) Parar` | Detiene el contenedor si está en ejecución |
| `3) Ver logs` | Sigue los logs del contenedor en tiempo real |
| `4) Cancelar` | Sale del menú |

### Configuración por defecto

| Variable | Valor |
|----------|-------|
| Puerto host | `8085` |
| Puerto contenedor | `8080` |
| Nombre del contenedor | `plantuml-render` |
| Imagen | `plantuml/plantuml-server:jetty` |

### URL de uso

Cuando el servicio está activo, puedes usar:

```text
http://localhost:8085
```

Para obtener un diagrama desde texto codificado en URL, el endpoint típico es:

```text
http://localhost:8085/svg/<encoded-diagram>
```

> Requisito: `podman` debe estar instalado y disponible en el PATH.

---

## Añadir un Nuevo Script

1. Crea tu script en `~/.dotfiles/scripts/mi-script`
2. Hazlo ejecutable: `chmod +x ~/.dotfiles/scripts/mi-script`
3. El install.sh ya gestiona los enlaces simbólicos — vuelve a ejecutarlo o crea el enlace manualmente:

```bash
ln -sf ~/.dotfiles/scripts/mi-script ~/.local/bin/mi-script
```

Tu script ya está disponible como `mi-script` desde cualquier lugar.

### Plantilla de script

```bash
#!/usr/bin/env bash
# =============================================================================
# mi-script — Descripción breve
# Uso: mi-script [opciones]
# =============================================================================
set -euo pipefail

BOLD='\033[1m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'
RED='\033[0;31m'; RESET='\033[0m'

step()    { echo -e "\n${BOLD}${CYAN}▶ $*${RESET}"; }
success() { echo -e "${GREEN}✓${RESET} $*"; }
error()   { echo -e "${RED}✗${RESET} $*" >&2; exit 1; }

# Tu código aquí
step "Haciendo algo"
echo "¡Hola!"
success "Listo."
```
