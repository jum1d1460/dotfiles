# 🖥️ WezTerm — Terminal Emulator

WezTerm is a GPU-accelerated terminal emulator configured entirely in Lua.

**Config file:** `~/.wezterm.lua` (symlinked from `~/.dotfiles/wezterm/.wezterm.lua`)  
**Installed via:** Flatpak (`org.wezfurlong.wezterm`)

---

## Starting WezTerm

```bash
# From GNOME application launcher: search "WezTerm"
# From another terminal:
flatpak run org.wezfurlong.wezterm
```

> **Note:** WezTerm is forced to run under XWayland (not native Wayland). This is intentional — the `install.sh` creates a `.desktop` override at `~/.local/share/applications/org.wezfurlong.wezterm.desktop` with `WAYLAND_DISPLAY=""` to avoid rendering issues on Wayland compositors.

---

## Visual Style

| Setting | Value |
|---------|-------|
| Font | JetBrainsMono Nerd Font, 13pt |
| Line height | 1.2 |
| Background opacity | 90% (glass effect) |
| Window decorations | None (no title bar, no borders) |
| Padding | 12px horizontal, 10px vertical |
| Cursor | Blinking bar |
| Tab bar | Bottom of window, hidden if single tab |
| Scrollback | 10,000 lines |
| Rendering | WebGPU (hardware accelerated) |
| FPS | Up to 120 fps |

---

## Leader Key

The **leader key** is `Ctrl+A` (tmux-style). Press and release it, then press the second key within 1 second.

---

## Key Bindings

### Pane Management

| Binding | Action |
|---------|--------|
| `Ctrl+A` → `-` | Split pane **vertically** (new pane below) |
| `Ctrl+A` → `\|` | Split pane **horizontally** (new pane to the right) |
| `Ctrl+A` → `w` | **Close** current pane (with confirmation) |

### Pane Navigation (Vim-style)

| Binding | Action |
|---------|--------|
| `Ctrl+A` → `h` | Move to pane on the **left** |
| `Ctrl+A` → `j` | Move to pane **below** |
| `Ctrl+A` → `k` | Move to pane **above** |
| `Ctrl+A` → `l` | Move to pane on the **right** |

### Pane Resizing

| Binding | Action |
|---------|--------|
| `Ctrl+A` → `H` | Resize pane **left** (shrink width) |
| `Ctrl+A` → `J` | Resize pane **down** (grow height) |
| `Ctrl+A` → `K` | Resize pane **up** (shrink height) |
| `Ctrl+A` → `L` | Resize pane **right** (grow width) |

### Tabs

| Binding | Action |
|---------|--------|
| `Ctrl+A` → `c` | **New** tab |
| `Ctrl+A` → `n` | **Next** tab |
| `Ctrl+A` → `p` | **Previous** tab |

### Other

| Binding | Action |
|---------|--------|
| `Ctrl+A` → `[` | Enter **copy mode** (scroll/select text) |
| `Ctrl+=` | Increase font size |
| `Ctrl+-` | Decrease font size |
| `Ctrl+0` | Reset font size to default |
| Right-click | **Paste** from clipboard |

---

## Copy Mode

Enter copy mode with `Ctrl+A` → `[`. Navigate and select text using keyboard.

| Key | Action |
|-----|--------|
| `h j k l` | Move cursor (Vim-style) |
| `v` | Start selection |
| `V` | Select whole line |
| `y` | Yank (copy) selection |
| `q` or `Esc` | Exit copy mode |
| `Ctrl+F` | Search forward |
| `n` / `N` | Next / previous search match |

---

## Theme Integration

WezTerm reads its colour scheme from `~/.config/current-theme` on startup:

```lua
-- In ~/.wezterm.lua:
local themes = {
  catppuccin   = "Catppuccin Macchiato",
  ["tokyo-night"] = "Tokyo Night",
  dracula      = "Dracula (Official)",
}
```

Switch themes with:

```bash
theme-switcher catppuccin    # warm, pastel (default)
theme-switcher tokyo-night   # cool, dark blue/purple
theme-switcher dracula       # high-contrast pink/purple
```

The script sends `SIGUSR1` to reload WezTerm live — no restart needed.

---

## Modifying the Configuration

Edit `~/.dotfiles/wezterm/.wezterm.lua` and reload WezTerm:

```bash
# Reload config without restarting:
# Press Ctrl+A then Shift+R  (or just close and reopen WezTerm)

# Edit config:
vim ~/.dotfiles/wezterm/.wezterm.lua
```

WezTerm auto-reloads its config when the file changes. You'll see a notification in the top-right corner.

---

## Useful WezTerm CLI Commands

```bash
# Check WezTerm version
flatpak run org.wezfurlong.wezterm --version

# Open WezTerm with a specific command
flatpak run org.wezfurlong.wezterm start -- htop

# List all available colour schemes
flatpak run org.wezfurlong.wezterm ls-fonts
```
