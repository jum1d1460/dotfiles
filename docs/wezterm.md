# 🖥️ WezTerm — Emulador de Terminal

WezTerm es un emulador de terminal acelerado por GPU configurado completamente en Lua.

**Archivo de configuración:** `~/.wezterm.lua` (enlace simbólico de `~/.dotfiles/wezterm/.wezterm.lua`)  
**Instalado mediante:** Flatpak (`org.wezfurlong.wezterm`)

---

## Iniciar WezTerm

```bash
# Desde el lanzador de aplicaciones de GNOME: busca "WezTerm"
# Desde otra terminal:
flatpak run org.wezfurlong.wezterm
```

> **Nota:** WezTerm está forzado a ejecutarse bajo XWayland (no Wayland nativo). Esto es intencionado — `install.sh` crea un override de `.desktop` en `~/.local/share/applications/org.wezfurlong.wezterm.desktop` con `WAYLAND_DISPLAY=""` para evitar problemas de renderizado en compositors Wayland.

---

## Estilo Visual

| Ajuste | Valor |
|--------|-------|
| Fuente | JetBrainsMono Nerd Font, 13pt |
| Altura de línea | 1.2 |
| Opacidad del fondo | 90% (efecto cristal) |
| Decoraciones de ventana | Ninguna (sin barra de título ni bordes) |
| Relleno | 12px horizontal, 10px vertical |
| Cursor | Barra parpadeante |
| Barra de pestañas | Parte inferior, oculta si hay una sola pestaña |
| Desplazamiento | 10.000 líneas |
| Renderizado | WebGPU (acelerado por hardware) |
| FPS | Hasta 120 fps |

---

## Tecla Líder

La **tecla líder** es `Ctrl+A` (estilo tmux). Presiónala y suéltala, luego pulsa la segunda tecla en menos de 1 segundo.

---

## Atajos de Teclado

### Gestión de Paneles

| Atajo | Acción |
|-------|--------|
| `Ctrl+A` → `-` | Dividir panel **verticalmente** (nuevo panel debajo) |
| `Ctrl+A` → `\|` | Dividir panel **horizontalmente** (nuevo panel a la derecha) |
| `Ctrl+A` → `w` | **Cerrar** panel actual (con confirmación) |

### Navegación por Paneles (estilo Vim)

| Atajo | Acción |
|-------|--------|
| `Ctrl+A` → `h` | Moverse al panel de la **izquierda** |
| `Ctrl+A` → `j` | Moverse al panel de **abajo** |
| `Ctrl+A` → `k` | Moverse al panel de **arriba** |
| `Ctrl+A` → `l` | Moverse al panel de la **derecha** |

### Redimensionar Paneles

| Atajo | Acción |
|-------|--------|
| `Ctrl+A` → `H` | Redimensionar panel hacia la **izquierda** (reducir ancho) |
| `Ctrl+A` → `J` | Redimensionar panel hacia **abajo** (aumentar alto) |
| `Ctrl+A` → `K` | Redimensionar panel hacia **arriba** (reducir alto) |
| `Ctrl+A` → `L` | Redimensionar panel hacia la **derecha** (aumentar ancho) |

### Pestañas

| Atajo | Acción |
|-------|--------|
| `Ctrl+A` → `c` | **Nueva** pestaña |
| `Ctrl+A` → `n` | Pestaña **siguiente** |
| `Ctrl+A` → `p` | Pestaña **anterior** |

### Otros

| Atajo | Acción |
|-------|--------|
| `Ctrl+A` → `[` | Entrar en **modo copia** (desplazarse y seleccionar texto) |
| `Ctrl+=` | Aumentar tamaño de fuente |
| `Ctrl+-` | Reducir tamaño de fuente |
| `Ctrl+0` | Restablecer tamaño de fuente por defecto |
| Clic derecho | **Pegar** desde el portapapeles |

---

## Modo Copia

Entra en modo copia con `Ctrl+A` → `[`. Navega y selecciona texto con el teclado.

| Tecla | Acción |
|-------|--------|
| `h j k l` | Mover el cursor (estilo Vim) |
| `v` | Iniciar selección |
| `V` | Seleccionar línea completa |
| `y` | Copiar selección (yank) |
| `q` o `Esc` | Salir del modo copia |
| `Ctrl+F` | Buscar hacia adelante |
| `n` / `N` | Siguiente / anterior coincidencia de búsqueda |

---

## Integración de Temas

WezTerm lee su esquema de colores desde `~/.config/current-theme` al iniciar:

```lua
-- En ~/.wezterm.lua:
local themes = {
  catppuccin   = "Catppuccin Macchiato",
  ["tokyo-night"] = "Tokyo Night",
  dracula      = "Dracula (Official)",
}
```

Cambia de tema con:

```bash
theme-switcher catppuccin    # cálido, pastel (por defecto)
theme-switcher tokyo-night   # frío, azul oscuro/morado
theme-switcher dracula       # alto contraste rosa/morado
```

El script envía `SIGUSR1` para recargar WezTerm en directo — no se necesita reiniciar.

---

## Modificar la Configuración

Edita `~/.dotfiles/wezterm/.wezterm.lua` y recarga WezTerm:

```bash
# Recargar la configuración sin reiniciar:
# Pulsa Ctrl+A y luego Shift+R  (o simplemente cierra y vuelve a abrir WezTerm)

# Editar la configuración:
vim ~/.dotfiles/wezterm/.wezterm.lua
```

WezTerm recarga su configuración automáticamente cuando el archivo cambia. Verás una notificación en la esquina superior derecha.

---

## Comandos CLI Útiles de WezTerm

```bash
# Comprobar la versión de WezTerm
flatpak run org.wezfurlong.wezterm --version

# Abrir WezTerm con un comando específico
flatpak run org.wezfurlong.wezterm start -- htop

# Listar todos los esquemas de colores disponibles
flatpak run org.wezfurlong.wezterm ls-fonts
```
