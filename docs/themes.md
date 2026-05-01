# 🎨 Theme System

Your terminal environment uses a unified theme system that changes the colour scheme of **WezTerm**, **bat**, and **Starship** simultaneously with a single command.

---

## Available Themes

| Theme | ID | Style |
|-------|----|-------|
| Catppuccin Macchiato | `catppuccin` | Warm, soft pastels — **default** |
| Tokyo Night | `tokyo-night` | Cool dark blues and purples |
| Dracula | `dracula` | High-contrast pink and purple |

---

## Switching Themes

```bash
theme-switcher catppuccin      # warm pastel (default)
theme-switcher tokyo-night     # cool dark blue/purple
theme-switcher dracula         # high contrast pink/purple
```

The command updates all three components **simultaneously**:

1. **WezTerm** — writes `~/.config/current-theme` and sends `SIGUSR1` to reload live
2. **bat** — updates `~/.config/bat/config` with `--theme=<name>`
3. **Starship** — updates the `palette =` line in `~/.config/starship.toml`
4. **GNOME wallpaper** _(optional)_ — if a matching image exists in `~/.local/share/wallpapers/`

> **Live reload:** WezTerm reloads instantly without restarting. bat and Starship pick up the change immediately in new commands. For the current shell session, run `reload` to refresh bat's theme variable.

---

## How the Theme File Works

The active theme name is stored in a plain text file:

```bash
cat ~/.config/current-theme    # shows active theme name, e.g. "catppuccin"
```

WezTerm reads this file on startup via `~/.wezterm.lua`:

```lua
local f = io.open(wezterm.home_dir .. "/.config/current-theme", "r")
local name = f:read("*l"):gsub("%s+", "")
config.color_scheme = themes[name] or themes["catppuccin"]
```

---

## Adding a New Theme

Follow these 4 steps to add a custom theme (example: `gruvbox`):

### Step 1 — Register it in `scripts/theme-switcher`

Open `~/.dotfiles/scripts/theme-switcher` and add to each array:

```bash
# WezTerm colour scheme name (must match a built-in or custom scheme):
["gruvbox"]="GruvboxDark"

# bat theme name (run `bat --list-themes` to see available names):
["gruvbox"]="gruvbox-dark"

# Starship palette name (must match a [palettes.xxx] block in starship.toml):
["gruvbox"]="gruvbox"
```

### Step 2 — Add a Starship palette

Open `~/.dotfiles/starship/.config/starship.toml` and add:

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

### Step 3 — (Optional) Add a wallpaper

```bash
mkdir -p ~/.local/share/wallpapers
cp ~/Downloads/gruvbox-wallpaper.jpg ~/.local/share/wallpapers/gruvbox.jpg
```

### Step 4 — Apply it

```bash
theme-switcher gruvbox
```

---

## Colours per Theme

### Catppuccin Macchiato (default)

Warm, pastel colour palette. Based on the [Catppuccin](https://catppuccin.com/) theme family.

| Colour | Hex |
|--------|-----|
| Background | `#24273a` |
| Text | `#cad3f5` |
| Blue | `#8aadf4` |
| Green | `#a6da95` |
| Red | `#ed8796` |
| Purple/Mauve | `#c6a0f6` |
| Yellow/Peach | `#f5a97f` |

### Tokyo Night

Cool, dark theme inspired by Tokyo at night. Popular with developers who prefer blues and purples.

| Colour | Hex |
|--------|-----|
| Background | `#1a1b26` |
| Blue | `#7aa2f7` |
| Cyan | `#7dcfff` |
| Green | `#9ece6a` |
| Magenta | `#bb9af7` |
| Red | `#f7768e` |
| Yellow | `#e0af68` |

### Dracula

High-contrast theme with vivid pinks and purples. Excellent readability, popular choice for presentations.

| Colour | Hex |
|--------|-----|
| Background | `#282a36` |
| Foreground | `#f8f8f2` |
| Pink | `#ff79c6` |
| Purple | `#bd93f9` |
| Cyan | `#8be9fd` |
| Green | `#50fa7b` |
| Red | `#ff5555` |
| Yellow | `#f1fa8c` |

---

## Troubleshooting Themes

**WezTerm not changing colour:**

```bash
# Check what theme is currently active
cat ~/.config/current-theme

# Force reload WezTerm (close and reopen if SIGUSR1 didn't work)
# Or send signal manually:
pkill -SIGUSR1 -x wezterm-gui
```

**bat still showing old theme:**

```bash
# Check bat config
cat ~/.config/bat/config

# Reload in current shell
reload    # alias for: source ~/.zshrc
```

**Starship palette not updating:**

```bash
# Check starship config
grep "^palette" ~/.config/starship.toml

# Re-run the switcher
theme-switcher catppuccin
```
