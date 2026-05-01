# 📜 Scripts

Custom scripts are located in `~/.dotfiles/scripts/` and symlinked to `~/.local/bin/` during installation, making them available as plain commands from anywhere.

---

## `up` — Full System Updater

**Location:** `~/.dotfiles/bin/.local/bin/up`  
**Symlinked to:** `~/.local/bin/up`

Runs a complete system update in one command:

```bash
up
```

### What it updates

| Step | Command | What it does |
|------|---------|-------------|
| 1 | `apt-get update && upgrade` | Ubuntu/Debian system packages |
| 2 | `apt-get autoremove` | Removes unused packages |
| 3 | `flatpak update` | All Flatpak applications (including WezTerm) |
| 4 | `nix profile upgrade '.*'` | All Nix-installed CLI tools |
| 5 | `nix store gc` | Garbage-collects unused Nix store paths (frees disk space) |
| 6 | `git pull` in each plugin dir | Updates Zsh plugins (autosuggestions, syntax-highlighting) |

### Partial updates

```bash
# Update only Nix packages
nix profile upgrade '.*'

# Update a specific Nix package
nix profile upgrade nixpkgs#bat

# Update only Flatpak apps
flatpak update

# Clean Nix store only
nix store gc

# Update only Zsh plugins
git -C ~/.zsh/plugins/zsh-autosuggestions pull --ff-only
git -C ~/.zsh/plugins/zsh-syntax-highlighting pull --ff-only
```

---

## `theme-switcher` — Theme Manager

**Location:** `~/.dotfiles/scripts/theme-switcher`  
**Symlinked to:** `~/.local/bin/theme-switcher`

Switches the colour scheme for WezTerm, bat, and Starship simultaneously.

```bash
theme-switcher catppuccin      # warm pastels (default)
theme-switcher tokyo-night     # dark blues and purples
theme-switcher dracula         # high-contrast pink/purple

# No argument — shows usage and available themes:
theme-switcher
```

### What gets changed

| Component | File modified |
|-----------|--------------|
| WezTerm | `~/.config/current-theme` (read on startup / live reload via SIGUSR1) |
| bat | `--theme=` line in `~/.config/bat/config` |
| Starship | `palette =` line in `~/.config/starship.toml` |
| GNOME wallpaper | via `gsettings` (only if matching image exists in `~/.local/share/wallpapers/`) |

See `docs/themes.md` for full details on adding new themes.

---

## `docs` — Documentation Browser

**Location:** `~/.dotfiles/scripts/docs`  
**Symlinked to:** `~/.local/bin/docs`  
**Alias:** `docs` (also set in `~/.zshrc`)

Opens the interactive documentation browser in the terminal using `glow`.

```bash
docs                     # open interactive documentation browser
docs tools               # open the tools reference directly
docs wezterm             # open WezTerm docs directly
docs zsh                 # open Zsh docs directly
docs themes              # open theme system docs
docs scripts             # open this file
docs stow                # open GNU Stow guide
docs troubleshooting     # open troubleshooting guide
```

### Inside the documentation browser

| Key | Action |
|-----|--------|
| ↑ ↓ | Navigate files |
| `Enter` | Open selected document |
| `Esc` | Go back to file list |
| `/` | Search within document |
| `q` | Quit |

---

## Adding a New Script

1. Create your script in `~/.dotfiles/scripts/my-script`
2. Make it executable: `chmod +x ~/.dotfiles/scripts/my-script`
3. The install.sh already handles symlinking — re-run it or create the symlink manually:

```bash
ln -sf ~/.dotfiles/scripts/my-script ~/.local/bin/my-script
```

Your script is now available as `my-script` from anywhere.

### Script template

```bash
#!/usr/bin/env bash
# =============================================================================
# my-script — Short description
# Usage: my-script [options]
# =============================================================================
set -euo pipefail

BOLD='\033[1m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'
RED='\033[0;31m'; RESET='\033[0m'

step()    { echo -e "\n${BOLD}${CYAN}▶ $*${RESET}"; }
success() { echo -e "${GREEN}✓${RESET} $*"; }
error()   { echo -e "${RED}✗${RESET} $*" >&2; exit 1; }

# Your code here
step "Doing something"
echo "Hello!"
success "Done."
```
