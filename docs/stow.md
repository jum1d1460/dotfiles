# 📦 GNU Stow — Despliegue de Dotfiles

GNU Stow es un **gestor de granjas de enlaces simbólicos**. Crea enlaces simbólicos en `$HOME` que apuntan a archivos dentro de tu repositorio `~/.dotfiles`, permitiéndote gestionar todos tus archivos de configuración en un único directorio bajo control de versiones.

---

## Cómo Funciona

Cada subdirectorio dentro de `~/.dotfiles/` es un **paquete Stow**. Cuando haces stow de un paquete, Stow replica su árbol de directorios interno creando enlaces simbólicos en `$HOME`.

**Ejemplo:**

```
~/.dotfiles/zsh/.zshrc
        ↓  stow zsh
~/.zshrc  →  ~/.dotfiles/zsh/.zshrc
```

```
~/.dotfiles/starship/.config/starship.toml
        ↓  stow starship
~/.config/starship.toml  →  ~/.dotfiles/starship/.config/starship.toml
```

---

## Paquetes de Este Repositorio

| Paquete | Fuente | Enlace simbólico destino |
|---------|--------|--------------------------|
| `zsh` | `zsh/.zshrc` | `~/.zshrc` |
| `wezterm` | `wezterm/.wezterm.lua` | `~/.wezterm.lua` |
| `starship` | `starship/.config/starship.toml` | `~/.config/starship.toml` |
| `bat` | `bat/.config/bat/config` | `~/.config/bat/config` |
| `bin` | `bin/.local/bin/up` | `~/.local/bin/up` |

---

## Comandos Habituales

Todos los comandos de Stow deben ejecutarse desde `~/.dotfiles/`:

```bash
cd ~/.dotfiles

# Stow un único paquete (crear enlaces simbólicos)
stow zsh

# Stow varios paquetes a la vez
stow zsh wezterm starship bat bin

# Stow todos los paquetes (re-stow = actualizar enlaces existentes)
stow --restow zsh wezterm starship bat bin

# Eliminar los enlaces simbólicos de un paquete (un-stow)
stow --delete zsh

# Simulacro — ver qué ocurriría sin hacer cambios
stow --simulate zsh
stow --simulate --verbose zsh

# Stow a un directorio destino personalizado
stow --target=/ruta/personalizada zsh
```

---

## Añadir un Nuevo Archivo de Configuración a Stow

Supón que quieres gestionar `~/.config/nvim/init.lua` con Stow:

```bash
cd ~/.dotfiles

# Crear la estructura de directorio del paquete
mkdir -p nvim/.config/nvim

# Mover el archivo real al paquete
mv ~/.config/nvim/init.lua nvim/.config/nvim/init.lua

# Hacer stow del paquete (crea el enlace simbólico)
stow nvim

# Verificar
ls -la ~/.config/nvim/init.lua
# ~/.config/nvim/init.lua -> ~/.dotfiles/nvim/.config/nvim/init.lua
```

---

## Gestión de Conflictos

Si un archivo destino ya existe (y no es un enlace simbólico), Stow se negará a sobreescribirlo:

```
WARNING! stow: existing target is not owned by stow: .zshrc
```

**Solución:**

```bash
# Hacer una copia de seguridad del archivo existente
mv ~/.zshrc ~/.zshrc.bak

# Hacer stow del paquete
stow zsh

# Opcionalmente, fusionar cualquier configuración personalizada del backup en el archivo stowed
```

---

## Comprobar el Estado de los Enlaces Simbólicos

```bash
# Comprobar si un archivo es un enlace simbólico y a dónde apunta
ls -la ~/.zshrc
# ~/.zshrc -> /home/usuario/.dotfiles/zsh/.zshrc

# Comprobar todos los enlaces simbólicos en el directorio de configuración
ls -la ~/.config/ | grep "\->"

# Encontrar todos los enlaces simbólicos que apuntan a dotfiles
find ~ -maxdepth 3 -type l 2>/dev/null | xargs -I{} sh -c 'ls -la "{}" 2>/dev/null | grep dotfiles'
```

---

## ¿Por Qué Stow en Lugar de Enlaces Simbólicos Manuales?

| Funcionalidad | `ln -sf` manual | GNU Stow |
|---------------|-----------------|----------|
| Eliminar un paquete | Borrar cada enlace manualmente | `stow --delete pkg` |
| Actualizar tras añadir archivos | Repetir cada comando `ln` | `stow --restow pkg` |
| Simulacro | No disponible | `stow --simulate pkg` |
| Gestionar directorios anidados | `mkdir` manual necesario | Automático |
| Un solo comando para todos los paquetes | No práctico | `stow zsh wezterm bat ...` |
