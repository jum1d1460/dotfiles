# 🔧 Troubleshooting

Common problems and their solutions.

---

## Nix

### `nix: command not found` after installation

```bash
# Source the Nix daemon environment
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Or restart your terminal
exec zsh
```

If it still fails, check that Nix was installed:

```bash
ls /nix/store
# Should list many hash-named directories
```

### Nix package install fails

```bash
# Try again with verbose output
nix profile install nixpkgs#bat --debug

# Check internet connectivity
curl -I https://cache.nixos.org

# Check disk space
df -h /nix
```

### `nix store gc` removes too much / breaks packages

```bash
# See what's in your profile
nix profile list

# Reinstall everything
nix profile install nixpkgs#bat nixpkgs#eza nixpkgs#fzf  # etc.

# Or re-run the installer
~/.dotfiles/install.sh
```

---

## Fonts & Icons

### Missing icons (boxes or question marks instead of symbols)

Icons require **JetBrainsMono Nerd Font** to be installed and set in WezTerm.

```bash
# Check if the font is installed
fc-list | grep -i JetBrains

# If missing, install it manually
FONT_DIR="${HOME}/.local/share/fonts"
mkdir -p "${FONT_DIR}"
curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip" \
  -o /tmp/JetBrainsMono.zip
unzip -q /tmp/JetBrainsMono.zip -d /tmp/jbm-fonts
cp /tmp/jbm-fonts/*.ttf "${FONT_DIR}/"
fc-cache -f
```

Then verify WezTerm is using the correct font:

```bash
grep "JetBrains" ~/.wezterm.lua
# Should show: family = "JetBrainsMono Nerd Font"
```

---

## Zsh Plugins

### Autosuggestions not working (no grey text)

```bash
# Check plugin is loaded
echo $ZSH_AUTOSUGGESTIONS_VERSION

# Check the plugin file exists
ls ~/.zsh/plugins/zsh-autosuggestions/

# Re-clone if missing
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
  ~/.zsh/plugins/zsh-autosuggestions
```

Then reload your shell:

```bash
reload   # alias for: source ~/.zshrc
```

### Syntax highlighting not working (no colours while typing)

```bash
# Check plugin is loaded
echo $ZSH_HIGHLIGHT_VERSION

# Check the plugin file exists
ls ~/.zsh/plugins/zsh-syntax-highlighting/

# Re-clone if missing
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.zsh/plugins/zsh-syntax-highlighting
```

> **Note:** `zsh-syntax-highlighting` **must** be the last plugin sourced. Check `~/.zshrc` — it should be the last `source` line.

---

## Stow

### "Existing target is not owned by stow" error

```bash
# Stow refuses to overwrite a file it didn't create.
# Back up the conflicting file, then stow:
mv ~/.zshrc ~/.zshrc.bak
stow zsh

# Merge any custom settings from the backup into the dotfiles version
```

### Symlinks not created after editing dotfiles

```bash
cd ~/.dotfiles

# Re-stow to update symlinks for any new files
stow --restow zsh wezterm starship bat bin

# Verify
ls -la ~/.zshrc ~/.wezterm.lua ~/.config/starship.toml
```

---

## Themes

### WezTerm not changing colour after `theme-switcher`

```bash
# Check the theme file was written
cat ~/.config/current-theme

# Try sending reload signal manually
pkill -SIGUSR1 -x wezterm-gui

# If that doesn't work, close and reopen WezTerm
```

### bat reporting "unknown theme"

bat ships with a limited set of built-in themes. Custom themes (like Catppuccin) need to be installed:

```bash
# List available themes
bat --list-themes

# Install Catppuccin Macchiato for bat
mkdir -p "$(bat --config-dir)/themes"
curl -fsSL "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme" \
  -o "$(bat --config-dir)/themes/Catppuccin Macchiato.tmTheme"
bat cache --build

# Verify
bat --list-themes | grep Catppuccin
```

### Starship palette not updating

```bash
# Check the current palette setting
grep "^palette" ~/.config/starship.toml

# Re-apply the theme
theme-switcher catppuccin

# Check the config file is writable
ls -la ~/.config/starship.toml
```

---

## WezTerm

### WezTerm crashes or won't open on Wayland

WezTerm is forced to use XWayland via a `.desktop` override. If the override is missing:

```bash
# Check the override exists
cat ~/.local/share/applications/org.wezfurlong.wezterm.desktop
# Should contain: Exec=env WAYLAND_DISPLAY="" ...

# Re-create it if missing (re-run the installer or create manually):
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

### WezTerm config syntax error

```bash
# Test the config without opening WezTerm
flatpak run org.wezfurlong.wezterm --config-file ~/.wezterm.lua show-keys

# Or check logs
journalctl --user -u app-flatpak-org.wezfurlong.wezterm.service --no-pager
```

---

## Shell (Zsh)

### Default shell is not Zsh

```bash
# Check current shell
echo $SHELL

# Change to Zsh
ZSH_PATH="$(command -v zsh)"
grep -qF "${ZSH_PATH}" /etc/shells || echo "${ZSH_PATH}" | sudo tee -a /etc/shells
chsh -s "${ZSH_PATH}"

# Log out and back in for the change to take effect
```

### `thefuck` not working

```bash
# Check if installed
thefuck --version

# Check alias is set in shell
alias | grep fuck

# Re-evaluate the alias in current session
eval "$(thefuck --alias)"
```

### fzf key bindings not working (`Ctrl+R`, `Ctrl+T`)

```bash
# Check fzf is installed
fzf --version

# Check the zsh integration is active
fzf --zsh   # should output shell functions

# It should be auto-initialized in .zshrc via:
# eval "$(fzf --zsh)"
# If missing, add it to ~/.dotfiles/zsh/.zshrc
```

---

## General

### A command is not found after installation

```bash
# Check if it's installed in the Nix profile
nix profile list | grep bat   # replace 'bat' with your tool

# Check if PATH includes Nix
echo $PATH | tr ':' '\n' | grep nix

# Source Nix environment
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Or restart terminal
exec zsh
```

### Re-running the installer safely

The installer is **idempotent** — it can be run multiple times safely. It skips steps that are already done:

```bash
~/.dotfiles/install.sh
```
