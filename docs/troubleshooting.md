# 🔧 Solución de Problemas

Problemas habituales y sus soluciones.

---

## Nix

### `nix: command not found` tras la instalación

```bash
# Cargar el entorno del daemon de Nix
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# O reiniciar la terminal
exec zsh
```

Si sigue sin funcionar, comprueba que Nix está instalado:

```bash
ls /nix/store
# Debe mostrar muchos directorios con nombre de hash
```

### La instalación de un paquete Nix falla

```bash
# Intentarlo de nuevo con salida detallada
nix profile install nixpkgs#bat --debug

# Comprobar conectividad a internet
curl -I https://cache.nixos.org

# Comprobar espacio en disco
df -h /nix
```

### `nix store gc` elimina demasiado / rompe paquetes

```bash
# Ver qué hay en tu perfil
nix profile list

# Reinstalar todo
nix profile install nixpkgs#bat nixpkgs#eza nixpkgs#fzf  # etc.

# O volver a ejecutar el instalador
~/.dotfiles/install.sh
```

---

## Fuentes e Iconos

### Iconos que no se muestran (cuadros o signos de interrogación en lugar de símbolos)

Los iconos requieren que **JetBrainsMono Nerd Font** esté instalada y configurada en WezTerm.

```bash
# Comprobar si la fuente está instalada
fc-list | grep -i JetBrains

# Si falta, instalarla manualmente
FONT_DIR="${HOME}/.local/share/fonts"
mkdir -p "${FONT_DIR}"
curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip" \
  -o /tmp/JetBrainsMono.zip
unzip -q /tmp/JetBrainsMono.zip -d /tmp/jbm-fonts
cp /tmp/jbm-fonts/*.ttf "${FONT_DIR}/"
fc-cache -f
```

Luego verifica que WezTerm usa la fuente correcta:

```bash
grep "JetBrains" ~/.wezterm.lua
# Debe mostrar: family = "JetBrainsMono Nerd Font"
```

---

## Plugins de Zsh

### Las autosuggestions no funcionan (sin texto gris)

```bash
# Comprobar que el plugin está cargado
echo $ZSH_AUTOSUGGESTIONS_VERSION

# Comprobar que existe el archivo del plugin
ls ~/.zsh/plugins/zsh-autosuggestions/

# Clonar de nuevo si falta
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
  ~/.zsh/plugins/zsh-autosuggestions
```

Luego recarga tu shell:

```bash
reload   # alias de: source ~/.zshrc
```

### El resaltado de sintaxis no funciona (sin colores al escribir)

```bash
# Comprobar que el plugin está cargado
echo $ZSH_HIGHLIGHT_VERSION

# Comprobar que existe el archivo del plugin
ls ~/.zsh/plugins/zsh-syntax-highlighting/

# Clonar de nuevo si falta
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.zsh/plugins/zsh-syntax-highlighting
```

> **Nota:** `zsh-syntax-highlighting` **debe** ser el último plugin que se cargue. Comprueba `~/.zshrc` — debe ser la última línea `source`.

---

## Stow

### Error "Existing target is not owned by stow"

```bash
# Stow se niega a sobreescribir un archivo que él no creó.
# Haz una copia de seguridad del archivo conflictivo y luego stow:
mv ~/.zshrc ~/.zshrc.bak
stow zsh

# Fusiona cualquier configuración personalizada del backup en la versión de dotfiles
```

### Los enlaces simbólicos no se crean tras editar los dotfiles

```bash
cd ~/.dotfiles

# Volver a hacer stow para actualizar los enlaces de los archivos nuevos
stow --restow zsh wezterm starship bat bin

# Verificar
ls -la ~/.zshrc ~/.wezterm.lua ~/.config/starship.toml
```

---

## Temas

### WezTerm no cambia de color tras `theme-switcher`

```bash
# Comprobar que el archivo de tema se ha escrito
cat ~/.config/current-theme

# Intentar enviar la señal de recarga manualmente
pkill -SIGUSR1 -x wezterm-gui

# Si no funciona, cerrar y volver a abrir WezTerm
```

### bat informa de "unknown theme" (tema desconocido)

bat incluye un conjunto limitado de temas integrados. Los temas personalizados (como Catppuccin) hay que instalarlos:

```bash
# Listar los temas disponibles
bat --list-themes

# Instalar Catppuccin Macchiato para bat
mkdir -p "$(bat --config-dir)/themes"
curl -fsSL "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme" \
  -o "$(bat --config-dir)/themes/Catppuccin Macchiato.tmTheme"
bat cache --build

# Verificar
bat --list-themes | grep Catppuccin
```

### La paleta de Starship no se actualiza

```bash
# Comprobar la configuración de paleta actual
grep "^palette" ~/.config/starship.toml

# Volver a aplicar el tema
theme-switcher catppuccin

# Comprobar que el archivo de configuración tiene permisos de escritura
ls -la ~/.config/starship.toml
```

---

## WezTerm

### WezTerm se cuelga o no abre en Wayland

WezTerm está forzado a usar XWayland mediante un override de `.desktop`. Si falta el override:

```bash
# Comprobar que el override existe
cat ~/.local/share/applications/org.wezfurlong.wezterm.desktop
# Debe contener: Exec=env WAYLAND_DISPLAY="" ...

# Recrearlo si falta (vuelve a ejecutar el instalador o créalo manualmente):
cat > ~/.local/share/applications/org.wezfurlong.wezterm.desktop << 'EOF'
[Desktop Entry]
Name=WezTerm
Comment=Wez's Terminal Emulator
Exec=env WAYLAND_DISPLAY="" flatpak run org.wezfurlong.wezterm
Icon=org.wezfurlong.wezterm
Terminal=false
Type=Application
Categories=System;TerminalEmulator;
EOF
update-desktop-database ~/.local/share/applications
```

### Error de sintaxis en la configuración de WezTerm

```bash
# Probar la configuración sin abrir WezTerm
flatpak run org.wezfurlong.wezterm --config-file ~/.wezterm.lua show-keys

# O comprobar los registros
journalctl --user -u app-flatpak-org.wezfurlong.wezterm.service --no-pager
```

---

## Shell (Zsh)

### El shell por defecto no es Zsh

```bash
# Comprobar el shell actual
echo $SHELL

# Cambiar a Zsh
ZSH_PATH="$(command -v zsh)"
grep -qF "${ZSH_PATH}" /etc/shells || echo "${ZSH_PATH}" | sudo tee -a /etc/shells
chsh -s "${ZSH_PATH}"

# Cerrar sesión y volver a entrar para que el cambio surta efecto
```

### `thefuck` no funciona

```bash
# Comprobar si está instalado
thefuck --version

# Comprobar que el alias está definido en el shell
alias | grep fuck

# Volver a evaluar el alias en la sesión actual
eval "$(thefuck --alias)"
```

### Los atajos de fzf no funcionan (`Ctrl+R`, `Ctrl+T`)

```bash
# Comprobar que fzf está instalado
fzf --version

# Comprobar que la integración con zsh está activa
fzf --zsh   # debe mostrar funciones de shell

# Debe inicializarse automáticamente en .zshrc mediante:
# eval "$(fzf --zsh)"
# Si falta, añádelo a ~/.dotfiles/zsh/.zshrc
```

---

## General

### Un comando no se encuentra tras la instalación

```bash
# Comprobar si está instalado en el perfil Nix
nix profile list | grep bat   # sustituye 'bat' por tu herramienta

# Comprobar que PATH incluye Nix
echo $PATH | tr ':' '\n' | grep nix

# Cargar el entorno de Nix
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# O reiniciar la terminal
exec zsh
```

### Volver a ejecutar el instalador de forma segura

El instalador es **idempotente** — puede ejecutarse múltiples veces sin problemas. Omite los pasos que ya están completados:

```bash
~/.dotfiles/install.sh
```
