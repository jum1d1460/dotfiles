# 🐚 Zsh — Configuración del Shell

Tu shell es **Zsh**, configurado para máxima productividad con plugins modernos, historial inteligente y un conjunto cuidado de alias.

**Archivo de configuración:** `~/.zshrc` (enlace simbólico de `~/.dotfiles/zsh/.zshrc`)

---

## Plugins

| Plugin | Efecto |
|--------|--------|
| `zsh-autosuggestions` | Texto fantasma gris que muestra sugerencias del historial mientras escribes. Pulsa `→` o `Fin` para aceptar. |
| `zsh-syntax-highlighting` | Los comandos se muestran en verde cuando son válidos y en rojo cuando no se encuentran, mientras escribes. |

Ambos plugins se clonan en `~/.zsh/plugins/` durante la instalación.

---

## Opciones del Shell

| Opción | Efecto |
|--------|--------|
| `AUTO_CD` | Escribe el nombre de un directorio para entrar en él (sin necesidad de `cd`) |
| `AUTO_PUSHD` | Cada `cd` guarda el directorio anterior en una pila (`popd` para volver) |
| `CORRECT` | Sugiere correcciones para comandos mal escritos |
| `INTERACTIVE_COMMENTS` | Puedes escribir `# comentarios` en el shell interactivo |

---

## Historial

| Ajuste | Valor |
|--------|-------|
| Tamaño del historial | 1.000.000 entradas |
| Guardado en disco | `~/.zsh_history` |
| Compartido entre sesiones | ✅ (todos los terminales abiertos comparten el historial) |
| Marcas de tiempo guardadas | ✅ |
| Duplicados eliminados | ✅ |
| Escrito inmediatamente | ✅ (no solo al cerrar el shell) |

---

## Autocompletado con Tab

- Pulsa `Tab` para completar comandos, rutas y argumentos
- Pulsa `Tab Tab` para abrir un menú interactivo
- Usa las flechas para navegar por el menú
- El completado es **insensible a mayúsculas** por defecto
- El menú de completado hereda los colores de `LS_COLORS`

---

## Atajos de Teclado

### Integración con fzf

| Atajo | Acción |
|-------|--------|
| `Ctrl+R` | **Búsqueda difusa en el historial** — encontrar cualquier comando pasado |
| `Ctrl+T` | **Selector difuso de archivos** — seleccionar un archivo y pegar su ruta |
| `Alt+C` | **Selector difuso de directorios** — `cd` al directorio seleccionado |

### Zsh Estándar

| Atajo | Acción |
|-------|--------|
| `Ctrl+A` | Mover el cursor al principio de la línea |
| `Ctrl+E` | Mover el cursor al final de la línea |
| `Ctrl+W` | Eliminar la palabra anterior al cursor |
| `Ctrl+U` | Eliminar toda la línea |
| `Ctrl+K` | Eliminar desde el cursor hasta el final de la línea |
| `Ctrl+L` | Limpiar la pantalla |
| `Ctrl+C` | Cancelar el comando actual |
| `Ctrl+Z` | Suspender el proceso actual (reanuda con `fg`) |
| `Alt+F` | Avanzar una palabra |
| `Alt+B` | Retroceder una palabra |

---

## Alias — Operaciones con Archivos

| Alias | Expande a | Notas |
|-------|-----------|-------|
| `cat` | `bat --paging=never` | Vista de archivos con resaltado de sintaxis |
| `less` | `bat --paging=always` | Vista desplazable con resaltado de sintaxis |
| `ls` | `eza --icons --group-directories-first` | Iconos, directorios primero |
| `ll` | `eza --icons --long --group-directories-first --git` | Formato largo con Git |
| `la` | `eza --icons --long --all --group-directories-first --git` | Incluye ocultos |
| `lt` | `eza --icons --tree --level=2 --group-directories-first` | Vista en árbol |
| `lta` | `eza --icons --tree --level=2 --all --group-directories-first` | Árbol + ocultos |
| `mkdir` | `mkdir -p` | Crea directorios padre automáticamente |
| `cp` | `cp -i` | Pregunta antes de sobreescribir |
| `mv` | `mv -i` | Pregunta antes de sobreescribir |
| `rm` | `rm -i` | Pregunta antes de eliminar |
| `grep` | `grep --color=auto` | Siempre coloriza las coincidencias |

---

## Alias — Navegación

| Alias | Expande a |
|-------|-----------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |

---

## Alias — Sistema

| Alias | Expande a | Notas |
|-------|-----------|-------|
| `top` | `btop` | Monitor de procesos gráfico |
| `df` | `df -h` | Uso de disco legible por humanos |
| `du` | `du -h` | Tamaño de directorios legible por humanos |
| `free` | `free -h` | Memoria legible por humanos |
| `ps` | `ps auxf` | Árbol completo de procesos |
| `reload` | `source ~/.zshrc` | Recargar la configuración de Zsh |
| `help` | `tldr` | Ejemplos rápidos de comandos |

---

## Alias — Git

| Alias | Expande a |
|-------|-----------|
| `gs` | `git status` |
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gc` | `git commit` |
| `gcm` | `git commit -m` |
| `gp` | `git push` |
| `gpl` | `git pull` |
| `gf` | `git fetch --all --prune` |
| `gb` | `git branch` |
| `gco` | `git checkout` |
| `gsw` | `git switch` |
| `gl` | `git log` (gráfico, con colores, todas las ramas) |
| `gd` | `git diff` (vía delta) |
| `gds` | `git diff --staged` (vía delta) |
| `grb` | `git rebase` |
| `gst` | `git stash` |
| `gstp` | `git stash pop` |
| `lg` | `lazygit` (cliente Git en TUI) |

---

## Variables de Entorno

| Variable | Valor | Propósito |
|----------|-------|-----------|
| `EDITOR` | `vim` | Editor por defecto (usado por git, cron, etc.) |
| `VISUAL` | igual que `EDITOR` | Editor gráfico alternativo |
| `BAT_STYLE` | `numbers,changes,header` | Estilo de decoración de bat |
| `BAT_THEME` | `Catppuccin Macchiato` (por defecto) | Tema de colores de bat |
| `GIT_PAGER` | `delta` | Los diffs de git pasan por delta |
| `MANPAGER` | `bat -l man` | Las páginas de manual se renderizan con bat |
| `FZF_DEFAULT_COMMAND` | `fd --type f ...` | fzf usa fd para buscar archivos |
| `PATH` | `~/.local/bin`, `~/.nix-profile/bin`, ... | Rutas de búsqueda de herramientas |

---

## Modificar la Configuración

```bash
# Editar la configuración en el repositorio de dotfiles
vim ~/.dotfiles/zsh/.zshrc

# Aplicar los cambios a la sesión actual
reload   # alias de: source ~/.zshrc

# O abre una nueva pestaña de terminal
```

> **Nota:** Edita siempre `~/.dotfiles/zsh/.zshrc`, no `~/.zshrc` directamente.  
> `~/.zshrc` es un enlace simbólico gestionado por Stow — editarlo directamente también funciona (es el mismo archivo), pero mantener los cambios en `~/.dotfiles` los deja bajo control de versiones.

---

## Comprobar el Estado de los Plugins

```bash
# Verificar que los plugins están cargados
echo $ZSH_AUTOSUGGESTIONS_VERSION   # debe mostrar una versión
echo $ZSH_HIGHLIGHT_VERSION         # debe mostrar una versión

# O comprobar que los archivos de plugin existen
ls ~/.zsh/plugins/
```
