# 🎨 Sistema de Temas

Tu entorno de terminal utiliza un sistema de temas unificado que cambia el esquema de colores de **WezTerm**, **bat** y **Starship** simultáneamente con un solo comando.

---

## Temas Disponibles

| Tema | ID | Estilo |
|------|----|--------|
| Catppuccin Macchiato | `catppuccin` | Pasteles cálidos y suaves — **por defecto** |
| Tokyo Night | `tokyo-night` | Azules y morados oscuros y fríos |
| Dracula | `dracula` | Alto contraste con rosas y morados |

---

## Cambiar de Tema

```bash
theme-switcher catppuccin      # pasteles cálidos (por defecto)
theme-switcher tokyo-night     # azul oscuro/morado frío
theme-switcher dracula         # alto contraste rosa/morado
```

El comando actualiza los tres componentes **simultáneamente**:

1. **WezTerm** — escribe `~/.config/current-theme` y envía `SIGUSR1` para recarga en directo
2. **bat** — actualiza `~/.config/bat/config` con `--theme=<nombre>`
3. **Starship** — actualiza la línea `palette =` en `~/.config/starship.toml`
4. **Fondo de GNOME** _(opcional)_ — si existe una imagen correspondiente en `~/.local/share/wallpapers/`

> **Recarga en directo:** WezTerm se recarga instantáneamente sin reiniciar. bat y Starship adoptan el cambio de inmediato en los nuevos comandos. Para la sesión de shell actual, ejecuta `reload` para refrescar la variable de tema de bat.

---

## Cómo Funciona el Archivo de Tema

El nombre del tema activo se almacena en un archivo de texto plano:

```bash
cat ~/.config/current-theme    # muestra el tema activo, ej. "catppuccin"
```

WezTerm lee este archivo al iniciar mediante `~/.wezterm.lua`:

```lua
local f = io.open(wezterm.home_dir .. "/.config/current-theme", "r")
local name = f:read("*l"):gsub("%s+", "")
config.color_scheme = themes[name] or themes["catppuccin"]
```

---

## Añadir un Nuevo Tema

Sigue estos 4 pasos para añadir un tema personalizado (ejemplo: `gruvbox`):

### Paso 1 — Regístralo en `scripts/theme-switcher`

Abre `~/.dotfiles/scripts/theme-switcher` y añádelo a cada array:

```bash
# Nombre del esquema de colores de WezTerm (debe coincidir con uno integrado o personalizado):
["gruvbox"]="GruvboxDark"

# Nombre del tema de bat (ejecuta `bat --list-themes` para ver los disponibles):
["gruvbox"]="gruvbox-dark"

# Nombre de la paleta de Starship (debe coincidir con un bloque [palettes.xxx] en starship.toml):
["gruvbox"]="gruvbox"
```

### Paso 2 — Añade una paleta de Starship

Abre `~/.dotfiles/starship/.config/starship.toml` y añade:

```toml
[palettes.gruvbox]
background = "#282828"
red        = "#cc241d"
green      = "#98971a"
yellow     = "#d79921"
blue       = "#458588"
purple     = "#b16286"
aqua       = "#689d6a"
gray       = "#a89984"
```

### Paso 3 — (Opcional) Añade un fondo de pantalla

```bash
mkdir -p ~/.local/share/wallpapers
cp ~/Descargas/fondo-gruvbox.jpg ~/.local/share/wallpapers/gruvbox.jpg
```

### Paso 4 — Aplícalo

```bash
theme-switcher gruvbox
```

---

## Colores por Tema

### Catppuccin Macchiato (por defecto)

Paleta de colores cálida y pastel. Basada en la familia de temas [Catppuccin](https://catppuccin.com/).

| Color | Hex |
|-------|-----|
| Fondo | `#24273a` |
| Texto | `#cad3f5` |
| Azul | `#8aadf4` |
| Verde | `#a6da95` |
| Rojo | `#ed8796` |
| Morado/Mauve | `#c6a0f6` |
| Amarillo/Melocotón | `#f5a97f` |

### Tokyo Night

Tema frío y oscuro inspirado en Tokio de noche. Popular entre desarrolladores que prefieren azules y morados.

| Color | Hex |
|-------|-----|
| Fondo | `#1a1b26` |
| Azul | `#7aa2f7` |
| Cian | `#7dcfff` |
| Verde | `#9ece6a` |
| Magenta | `#bb9af7` |
| Rojo | `#f7768e` |
| Amarillo | `#e0af68` |

### Dracula

Tema de alto contraste con rosas y morados vivos. Excelente legibilidad, opción popular para presentaciones.

| Color | Hex |
|-------|-----|
| Fondo | `#282a36` |
| Primer plano | `#f8f8f2` |
| Rosa | `#ff79c6` |
| Morado | `#bd93f9` |
| Cian | `#8be9fd` |
| Verde | `#50fa7b` |
| Rojo | `#ff5555` |
| Amarillo | `#f1fa8c` |

---

## Solución de Problemas con los Temas

**WezTerm no cambia de color:**

```bash
# Comprobar qué tema está activo actualmente
cat ~/.config/current-theme

# Forzar la recarga de WezTerm (cierra y abre si SIGUSR1 no funcionó)
# O enviar la señal manualmente:
pkill -SIGUSR1 -x wezterm-gui
```

**bat sigue mostrando el tema anterior:**

```bash
# Comprobar la configuración de bat
cat ~/.config/bat/config

# Recargar en la sesión actual
reload    # alias de: source ~/.zshrc
```

**La paleta de Starship no se actualiza:**

```bash
# Comprobar la configuración de paleta actual
grep "^palette" ~/.config/starship.toml

# Volver a ejecutar el cambiador de temas
theme-switcher catppuccin
```
