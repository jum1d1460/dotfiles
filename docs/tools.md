# 🛠️ Referencia de Herramientas CLI

Todas las herramientas están instaladas a través de **Nix** y disponibles inmediatamente tras ejecutar `install.sh`.

---

## Tabla de Sustituciones

| Clásico | Moderno | ¿Por qué cambiar? |
|---------|---------|-------------------|
| `cat` | `bat` | Resaltado de sintaxis, números de línea, marcadores de cambios Git |
| `ls` | `eza` | Iconos, estado Git, vista en árbol, tipos con colores |
| `find` | `fd` | Sintaxis más sencilla, mucho más rápido, respeta `.gitignore` |
| `grep` | `rg` | Mucho más rápido, respeta `.gitignore`, mejores valores por defecto |
| `cd` | `cd` (zoxide) | Aprende tus hábitos — salto difuso a directorios frecuentes |
| `top` | `btop` | Gráfico, controlado con ratón, muestra GPU/red/disco |
| `man` | `man` (vía bat) | Páginas de manual con resaltado de sintaxis |
| `--help` | `tldr` | Ejemplos prácticos y concisos |

---

## bat — Visor de Archivos con Resaltado de Sintaxis

**Qué es:** Sustituto de `cat` con resaltado de sintaxis, números de línea y marcadores de cambios Git.

```bash
bat archivo.py              # ver archivo con resaltado de sintaxis
bat -n archivo.py           # solo números de línea, sin otras decoraciones
bat --theme=Dracula arch.py # usar un tema específico
bat --list-themes           # listar todos los temas disponibles
bat -l json archivo.txt     # forzar resaltado JSON
bat -A archivo.txt          # mostrar caracteres no imprimibles
bat -r 1:50 archivo.py      # mostrar solo las líneas 1–50
```

**Archivo de configuración:** `~/.config/bat/config`  
**Tema activo:** gestionado por `theme-switcher` (por defecto: Catppuccin Macchiato)

> **Consejo:** `bat` está definido como alias de `cat` en tu shell. Usa `cat` con normalidad para obtener resaltado automático. Usa `\cat` para saltarte el alias.

---

## eza — Sustituto Moderno de ls

**Qué es:** Sustituto de `ls` con iconos, estado Git, tipos con colores y vista en árbol.

```bash
ls                       # listado básico (alias a eza con iconos)
ll                       # formato largo con estado Git
la                       # formato largo, incluye archivos ocultos
lt                       # vista en árbol (2 niveles)
lta                      # vista en árbol con archivos ocultos

eza --long --git --icons          # detallado con estado Git
eza --tree --level=3              # árbol, 3 niveles de profundidad
eza --long --sort=modified        # ordenar por fecha de modificación
eza --long --sort=size            # ordenar por tamaño (mayor al final)
eza -1                            # un archivo por línea
eza --group-directories-first     # directorios al principio
```

**Columna de estado Git:** muestra `M` (modificado), `N` (nuevo), `D` (eliminado) junto a los archivos rastreados.

---

## fd — Buscador de Archivos Rápido

**Qué es:** Sustituto de `find` — sintaxis más sencilla, mucho más rápido, respeta `.gitignore`.

```bash
fd patrón               # buscar archivos que coincidan (recursivo desde .)
fd -e py                # archivos con extensión .py
fd -t d imagenes        # directorios llamados "imagenes"
fd -t f -e md           # archivos Markdown específicamente
fd -H patrón            # incluir archivos ocultos
fd -I patrón            # ignorar las reglas de .gitignore
fd --max-depth 2 config # buscar solo 2 niveles de profundidad
fd patrón ~/proyectos   # buscar en un directorio específico
fd -x bat {}            # ejecutar bat sobre cada resultado (ejecución paralela)
```

> **Consejo:** `fd` es utilizado internamente por `fzf` (ver FZF_DEFAULT_COMMAND en tu `.zshrc`).

---

## rg (ripgrep) — Búsqueda de Texto Rápida

**Qué es:** Sustituto de `grep` — mucho más rápido, respeta `.gitignore`, excelentes valores por defecto.

```bash
rg TODO                  # buscar TODO en todos los archivos (recursivo)
rg "function foo"        # buscar frase exacta
rg -i todo               # búsqueda sin distinguir mayúsculas
rg -l patrón             # mostrar solo los nombres de archivo (sin líneas)
rg -c patrón             # contar coincidencias por archivo
rg -t py patrón          # buscar solo en archivos Python
rg -e patrón1 -e p2      # múltiples patrones (OR)
rg --no-ignore patrón    # ignorar las reglas de .gitignore
rg patrón ~/proyectos    # buscar en un directorio específico
rg -A3 -B3 patrón        # mostrar 3 líneas de contexto antes y después
rg -w palabra            # coincidir solo palabras completas
rg --hidden patrón       # incluir archivos ocultos
```

---

## fzf — Buscador Difuso

**Qué es:** Buscador difuso interactivo para archivos, historial y cualquier otra cosa.

### Atajos de teclado (siempre disponibles en tu shell)

| Atajo | Acción |
|-------|--------|
| `Ctrl+R` | Búsqueda difusa en el historial de comandos |
| `Ctrl+T` | Selector difuso de archivos (pega la ruta en la línea de comandos) |
| `Alt+C` | Selector difuso de directorios (`cd` al seleccionado) |

### Uso directo de fzf

```bash
fzf                      # selector interactivo de archivos
vim $(fzf)               # abrir el archivo seleccionado en vim
fzf --preview 'bat --color=always {}'    # con vista previa de sintaxis
fzf --multi              # seleccionar múltiples archivos con Tab
fzf -q "config"          # rellenar la búsqueda de antemano

# Pasar cualquier cosa por pipe a fzf
git branch | fzf         # seleccionar una rama git
cat /etc/hosts | fzf     # filtrar líneas de /etc/hosts
ls | fzf                 # seleccionar un archivo del directorio actual

# Pipeline combinado
git checkout $(git branch | fzf)   # cambio de rama interactivo
```

> **Panel de vista previa:** Tu `FZF_DEFAULT_OPTS` ya configura una vista previa con `bat` a la derecha. Pulsa `Ctrl+/` para mostrarla u ocultarla.

---

## zoxide — cd Inteligente

**Qué es:** Sustituto de `cd` que aprende tus hábitos de navegación y te permite saltar a directorios por nombre parcial.

```bash
cd proyectos             # salta al directorio más relevante que hayas visitado
cd proy/mi               # coincidencia parcial de ruta
cd -                     # ir al directorio anterior (comportamiento estándar)
zi                       # selector interactivo de directorios visitados (con fzf)
```

> **Cómo funciona:** Cada comando `cd` queda registrado. `zoxide` puntúa los directorios por frecuencia y recencia y salta al mejor resultado. Cuanto más uses un directorio, más fácil es llegar a él.

> **Nota:** `zoxide` está aliasado de forma transparente como `cd`, por lo que no hay que cambiar ningún hábito.

---

## delta — Diffs de Git Mejorados

**Qué es:** Visor de diffs para Git con diffs lado a lado, resaltado de sintaxis y números de línea. Reemplaza automáticamente el paginador integrado de Git.

```bash
git diff                 # usa delta automáticamente
git diff --staged        # cambios en el área de preparación, también vía delta
git log -p               # historial de commits con diffs
git show HEAD            # mostrar el último commit, renderizado por delta
gd                       # alias: git diff vía delta
gds                      # alias: git diff --staged vía delta
```

> **Sin configuración adicional** — delta está definido como tu `GIT_PAGER` en `.zshrc`. Todos los comandos `git diff` pasan por él automáticamente.

---

## lazygit — Cliente Git en TUI

**Qué es:** Interfaz de terminal completa para Git — preparar archivos, hacer commits, fusionar, rebasear y explorar el historial sin salir de la terminal.

```bash
lg                       # abrir lazygit (alias)
lazygit                  # lo mismo, sin alias
```

### Atajos de teclado dentro de lazygit

| Tecla | Acción |
|-------|--------|
| ↑ ↓ | Navegar por archivos / commits |
| `Space` | Preparar / quitar del área de preparación |
| `c` | Hacer commit de los cambios preparados |
| `p` | Push |
| `P` | Pull |
| `b` | Menú de ramas |
| `m` | Fusionar (merge) |
| `r` | Rebasear |
| `z` | Deshacer la última acción |
| `?` | Mostrar todos los atajos de teclado |
| `q` | Salir |

---

## btop — Monitor del Sistema

**Qué es:** Monitor del sistema gráfico y controlado con ratón que muestra CPU, memoria, red, disco y procesos.

```bash
top                      # alias a btop
btop                     # llamada directa
```

### Dentro de btop

| Tecla | Acción |
|-------|--------|
| `F1` o `?` | Ayuda |
| `F2` | Configuración |
| `↑ ↓` | Navegar por procesos |
| `k` | Terminar el proceso seleccionado |
| `f` | Filtrar procesos |
| `q` | Salir |
| Ratón | Hacer clic para interactuar con cualquier panel |

---

## tldr — Ejemplos Prácticos de Comandos

**Qué es:** Páginas de manual simplificadas con ejemplos prácticos en lugar de documentación técnica completa.

```bash
tldr git                 # ejemplos de git
tldr tar                 # cómo usar tar sin buscar en Google
tldr fd                  # ejemplos de fd
tldr curl                # ejemplos de curl
tldr --list              # listar todas las páginas disponibles
tldr --update            # actualizar la caché local
```

> **Consejo:** `alias help='tldr'` está definido en tu `.zshrc`. Puedes ejecutar `help git` como atajo.

---

## thefuck — Corrector de Comandos

**Qué es:** Corrige automáticamente el último comando mal escrito. Solo escribe `fuck` después de un error.

```bash
git comit -m "msg"       # ¡error tipográfico!
fuck                     # → ejecuta: git commit -m "msg"

apt-get install vim      # olvidaste sudo
fuck                     # → ejecuta: sudo apt-get install vim

gti status               # error tipográfico de git
fuck                     # → ejecuta: git status
```

> **Cómo funciona:** `thefuck --alias` se evalúa en tu `.zshrc`, lo que configura el comando `fuck`. Analiza el error del comando anterior y sugiere la corrección más probable.

---

## glow — Renderizador de Markdown

**Qué es:** Renderizado hermoso de Markdown en la terminal, con una TUI interactiva para explorar múltiples archivos.

```bash
glow README.md           # renderizar un archivo Markdown
glow -p README.md        # renderizar en paginador (desplazable, pulsa q para salir)
glow .                   # explorar todos los archivos .md del directorio actual (TUI)
glow ~/ruta/a/docs/      # explorar un directorio de documentación de forma interactiva
glow https://...         # renderizar Markdown remoto (URL)
```

### Dentro de la TUI de glow

| Tecla | Acción |
|-------|--------|
| ↑ ↓ | Navegar por archivos |
| `Enter` | Abrir archivo |
| `Esc` | Volver |
| `/` | Buscar |
| `q` | Salir |

> **Consejo:** Este sistema de documentación usa `glow`. Ejecuta `docs` para abrirlo.

---

## starship — Prompt del Shell

**Qué es:** Un prompt de shell minimal, rápido y altamente configurable que muestra información útil de contexto (directorio, rama git, duración del comando).

```bash
# Sin comandos directos — es tu prompt.
# Archivo de configuración: ~/.config/starship.toml

starship explain         # explica cada segmento del prompt actual
starship timings         # muestra cuánto tarda en renderizarse cada módulo
starship bug-report      # genera un informe de errores
```

**Segmentos del prompt:**

```
~/proyectos/mi-app  main ⇡2 !  took 3s
❯
```

| Segmento | Significado |
|----------|-------------|
| `~/proyectos/mi-app` | Directorio actual (truncado) |
| ` main` | Nombre de la rama Git |
| `⇡2` | 2 commits por delante del remoto |
| `!` | Modificaciones sin confirmar |
| `took 3s` | El último comando tardó 3 segundos |
| `❯` (verde) | El último comando tuvo éxito |
| `❯` (rojo) | El último comando falló |
