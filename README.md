# 🚀 Dotfiles — Ubuntu 2026 Modern Infrastructure

> macOS-style productivity on Ubuntu, powered by **Nix + Stow + Zsh**.

---

## Table of Contents

1. [Philosophy](#philosophy)
2. [Requirements](#requirements)
3. [Quick Start](#quick-start)
4. [Documentation Browser](#documentation-browser)
5. [Repository Structure](#repository-structure)
6. [Tools Reference](#tools-reference)
   - [Classic vs Modern Commands](#classic-vs-modern-commands)
7. [Configuration Details](#configuration-details)
   - [WezTerm](#wezterm)
   - [Starship](#starship)
   - [Zsh](#zsh)
   - [bat](#bat)
8. [Theme System](#theme-system)
   - [Available Themes](#available-themes)
   - [Switching Themes](#switching-themes)
   - [Adding a New Theme](#adding-a-new-theme)
9. [Quick Look / File Preview](#quick-look--file-preview)
10. [Scripts](#scripts)
11. [Stow Cheatsheet](#stow-cheatsheet)
12. [Updating the System](#updating-the-system)
13. [Troubleshooting](#troubleshooting)

---

## Philosophy

| Layer       | Tool              | Purpose                          |
|-------------|-------------------|----------------------------------|
| **GUI apps**| Flatpak (Flathub) | Sandboxed, up-to-date GUI apps   |
| **CLI/dev** | Nix (multi-user)  | Reproducible, isolated binaries  |
| **Dotfiles**| GNU Stow          | Symlink manager from this repo   |
| **Shell**   | Zsh + plugins     | Fast, modern shell experience    |
| **Terminal**| WezTerm           | GPU-accelerated, Lua-configured  |
| **Prompt**  | Starship          | Minimal, fast, informative       |

---

## Requirements

- Ubuntu 22.04 / 24.04 / 26.04 (or equivalent Debian)
- `curl`, `git` (pre-installed on most systems)
- GNOME desktop (for Quick Look and wallpaper features)

---

## Quick Start

```bash
# 1. Clone this repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Run the installer
chmod +x install.sh
./install.sh

# 3. Restart your terminal or log out and back in
exec zsh
```

---

## Documentation Browser

After installation, an interactive documentation system is available directly in the terminal:

```bash
docs                    # open interactive browser (navigate all docs)
docs tools              # CLI tools reference
docs wezterm            # WezTerm key bindings and configuration
docs zsh                # Zsh aliases, shortcuts, and settings
docs themes             # Theme system — switching and creating themes
docs scripts            # Scripts: up, theme-switcher, docs
docs stow               # GNU Stow cheatsheet
docs troubleshooting    # Common issues and fixes
```

The browser is powered by **[glow](https://github.com/charmbracelet/glow)** — a Markdown renderer with a TUI. Use ↑ ↓ to navigate, Enter to open, Esc to go back, `q` to quit.

The installer will:
1. Install system prerequisites via `apt`
2. Install **Nix** (multi-user / Determinate Nix)
3. Install all CLI tools via `nix profile install`
4. Install **WezTerm** via Flatpak + create a `.desktop` override to force XWayland (`env WAYLAND_DISPLAY=""`)
5. Download and install **JetBrainsMono Nerd Font**
6. Set **Zsh** as your default shell
7. Clone Zsh plugins (`autosuggestions`, `syntax-highlighting`)
8. **Stow** all dotfiles into your `$HOME`
9. Add the `scripts/` directory to `$PATH`
10. Configure Flathub and GNOME Sushi (Quick Look)

---

## Repository Structure

```
dotfiles/
├── install.sh                  # One-shot installer
├── README.md                   # This file
│
├── docs/                       # ← In-terminal documentation (browse with: docs)
│   ├── README.md               # Index / overview
│   ├── tools.md                # CLI tools reference
│   ├── wezterm.md              # WezTerm config & key bindings
│   ├── zsh.md                  # Zsh config, aliases, shortcuts
│   ├── themes.md               # Theme system
│   ├── scripts.md              # Scripts reference
│   ├── stow.md                 # GNU Stow guide
│   └── troubleshooting.md      # Common issues
│
├── zsh/                        # ← stow package
│   └── .zshrc
│
├── wezterm/                    # ← stow package
│   └── .wezterm.lua
│
├── starship/                   # ← stow package
│   └── .config/
│       └── starship.toml
│
├── bat/                        # ← stow package
│   └── .config/
│       └── bat/
│           └── config
│
├── bin/                        # ← stow package
│   └── .local/
│       └── bin/
│           └── up              # System update script
│
└── scripts/                    # Linked to ~/.local/bin/ by installer
    ├── theme-switcher          # Theme switching script
    └── docs                    # Documentation browser (launches glow)
```

> **How Stow works:** Running `stow <package>` from `~/.dotfiles` creates
> symlinks in `$HOME` that mirror the package's internal directory tree.
> For example, `dotfiles/zsh/.zshrc` → `~/.zshrc`.

---

## Tools Reference

### Classic vs Modern Commands

| Purpose             | Classic command     | Modern replacement     | Notes                                     |
|---------------------|---------------------|------------------------|-------------------------------------------|
| View file           | `cat`               | `bat`                  | Syntax highlighting, line numbers, paging |
| List files          | `ls`                | `eza`                  | Icons, Git status, tree view              |
| Find files          | `find`              | `fd`                   | Simpler syntax, faster, respects `.gitignore` |
| Search in files     | `grep`              | `rg` (ripgrep)         | Much faster, respects `.gitignore`        |
| Navigate dirs       | `cd`                | `cd` (zoxide)          | Learns your habits; `cd foo` jumps to best match |
| Fuzzy search        | —                   | `fzf`                  | Ctrl+R for history, Ctrl+T for files      |
| Git diff            | `git diff`          | `git diff` (delta)     | Side-by-side diff, syntax highlighting   |
| Git TUI             | —                   | `lazygit`              | Full-featured TUI for Git (`lg`)         |
| Process monitor     | `top`               | `btop`                 | Graphical, mouse-driven process monitor  |
| Read man pages      | `man`               | `man` (via bat)        | Syntax-highlighted man pages             |
| Command cheatsheet  | `man` / `--help`    | `tldr`                 | Practical examples for any command       |
| Fix typos           | —                   | `thefuck`              | Press `fuck` after a typo to fix it     |
| Render Markdown     | (none)              | `glow`                 | Beautiful Markdown in the terminal       |

#### Quick examples

```bash
# bat — view with syntax highlighting
bat ~/.zshrc

# eza — list with icons and git status
eza --long --git --icons

# eza — tree view
eza --tree --level=2

# fd — find all Lua files
fd -e lua

# rg — search for "TODO" in all files
rg TODO

# zoxide — jump to previously visited directory
cd proj   # jumps to ~/projects/my-project if visited before

# fzf — fuzzy file search
vim $(fzf)

# fzf — fuzzy history search
# Press Ctrl+R

# lazygit — TUI Git client
lg

# tldr — quick examples
tldr git
tldr fd

# glow — render a Markdown file
glow README.md

# thefuck — correct last command
git comit   # typo
fuck        # → runs: git commit
```

---

## Configuration Details

### WezTerm

File: `~/.wezterm.lua`

> **Installation note:** WezTerm is installed via **Flatpak** (not Nix).
> The Nix package has known issues on Wayland sessions.
> The installer automatically creates a user-level `.desktop` override at
> `~/.local/share/applications/org.wezfurlong.wezterm.desktop` that
> prepends `env WAYLAND_DISPLAY=""` to the `Exec=` line, forcing WezTerm
> to run under **XWayland** for stable rendering.

Key features:
- **No window decorations** (`window_decorations = "NONE"`) — pure, distraction-free terminal
- **90% background opacity** with blur for a glass effect
- **JetBrainsMono Nerd Font** with full ligature support (`calt`, `liga`, `clig`)
- **Leader key** = `Ctrl+A` (tmux-style)

#### Key bindings summary

| Binding         | Action                  |
|-----------------|-------------------------|
| `Ctrl+A` then `-` | Split pane vertically |
| `Ctrl+A` then `\|` | Split pane horizontally |
| `Ctrl+A` + `h/j/k/l` | Navigate panes (Vim-style) |
| `Ctrl+A` + `H/J/K/L` | Resize panes |
| `Ctrl+A` + `c` | New tab |
| `Ctrl+A` + `n/p` | Next / previous tab |
| `Ctrl+A` + `w` | Close pane |
| `Ctrl+A` + `[` | Copy mode |
| `Ctrl+=` / `Ctrl+-` | Increase / decrease font size |
| Right-click | Paste from clipboard |

---

### Starship

File: `~/.config/starship.toml`

The prompt shows:
```
~/projects/my-app  main ⇡2 !  took 3s
❯
```

| Segment       | What it shows                                     |
|---------------|---------------------------------------------------|
| Directory     | Truncated path (max 4 segments), repo-aware       |
| Git branch    | Branch name with `  ` icon, truncated at 25 chars |
| Git status    | `⇡` ahead, `⇣` behind, `!` modified, `+` staged  |
| Cmd duration  | Time taken for commands > 2 seconds               |
| Character     | `❯` (green = success, red = error)                |

Language modules (Node, Python, Rust, etc.) are **disabled by default** to keep the prompt minimal.

---

### Zsh

File: `~/.zshrc`

#### History

| Setting              | Value       |
|----------------------|-------------|
| `HISTSIZE`           | 1,000,000   |
| `SAVEHIST`           | 1,000,000   |
| Shared across shells | ✅          |
| Timestamps saved     | ✅          |
| Duplicates removed   | ✅          |

#### Keyboard shortcuts (fzf)

| Shortcut  | Action                              |
|-----------|-------------------------------------|
| `Ctrl+R`  | Fuzzy history search                |
| `Ctrl+T`  | Fuzzy file search (paste to line)   |
| `Alt+C`   | Fuzzy directory navigation (`cd`)   |

#### Git aliases

| Alias   | Command                                  |
|---------|------------------------------------------|
| `gs`    | `git status`                             |
| `ga`    | `git add`                                |
| `gaa`   | `git add --all`                          |
| `gc`    | `git commit`                             |
| `gcm`   | `git commit -m`                          |
| `gp`    | `git push`                               |
| `gpl`   | `git pull`                               |
| `gf`    | `git fetch --all --prune`                |
| `gb`    | `git branch`                             |
| `gco`   | `git checkout`                           |
| `gsw`   | `git switch`                             |
| `gl`    | `git log` (graphical, with colours)      |
| `gd`    | `git diff` (routed through delta)        |
| `gds`   | `git diff --staged`                      |
| `grb`   | `git rebase`                             |
| `gst`   | `git stash`                              |
| `gstp`  | `git stash pop`                          |
| `lg`    | `lazygit`                                |

---

### bat

File: `~/.config/bat/config`

`bat` replaces `cat` with syntax highlighting, line numbers, and Git change markers. Configured via:

```
--theme="Catppuccin Macchiato"
--style="numbers,changes,header"
```

The active theme is managed by `theme-switcher`.

---

## Theme System

### Available Themes

| Theme                  | ID             | Style                          |
|------------------------|----------------|--------------------------------|
| Catppuccin Macchiato   | `catppuccin`   | Warm, pastel — default         |
| Tokyo Night            | `tokyo-night`  | Cool, dark blue / purple       |
| Dracula                | `dracula`      | High-contrast pink / purple    |

### Switching Themes

```bash
# Apply Catppuccin Macchiato (default)
theme-switcher catppuccin

# Apply Tokyo Night
theme-switcher tokyo-night

# Apply Dracula
theme-switcher dracula
```

The script updates **all three** components simultaneously:
1. **WezTerm** — writes `~/.config/current-theme`, sends `SIGUSR1` to reload live
2. **bat** — updates `~/.config/bat/config` with the matching `--theme`
3. **Starship** — updates the `palette =` line in `~/.config/starship.toml`
4. **GNOME wallpaper** _(optional)_ — changes the desktop background if a matching image exists

### Adding a New Theme

Follow these steps to add a custom theme (e.g., `gruvbox`):

**1. Add the theme to `scripts/theme-switcher`:**

```bash
# In the WEZTERM_THEMES array:
["gruvbox"]="GruvboxDark"

# In the BAT_THEMES array:
["gruvbox"]="gruvbox-dark"

# In the STARSHIP_PALETTES array:
["gruvbox"]="gruvbox"
```

**2. Add a Starship palette in `starship/.config/starship.toml`:**

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

**3. (Optional) Add a wallpaper:**

```bash
mkdir -p ~/.local/share/wallpapers
cp ~/Downloads/gruvbox-wallpaper.jpg ~/.local/share/wallpapers/gruvbox.jpg
```

**4. Apply it:**

```bash
theme-switcher gruvbox
```

---

## Quick Look / File Preview

### GNOME Sushi (installed automatically)

[GNOME Sushi](https://gitlab.gnome.org/GNOME/sushi) adds Quick Look to the **Nautilus** file manager — exactly like macOS.

**Usage:**
1. Open **Files** (Nautilus)
2. Select any file
3. Press the **Space bar**

Supported file types: images, video, audio, PDF, text, fonts, and more.

### Terminal Previews

Use these tools for previewing files directly in the terminal:

```bash
# Preview any file with syntax highlighting
bat <file>

# Render Markdown beautifully
glow README.md
glow .          # browse all .md files interactively

# Browse files with fzf + bat preview
fzf --preview 'bat --color=always {}'

# Tree view of directory
eza --tree --level=3
```

### delta — Enhanced Git Diffs

`delta` is configured as the default Git pager, giving you:
- Side-by-side diffs
- Syntax highlighting
- Line numbers

```bash
git diff           # automatically uses delta
git diff --staged  # also uses delta
```

---

## Scripts

### `up` — Full System Updater

Located at `~/.local/bin/up` (symlinked from `bin/.local/bin/up`).

```bash
up
```

Runs in sequence:
1. `sudo apt-get update && apt-get upgrade` — Debian/Ubuntu packages
2. `flatpak update` — Flatpak apps
3. `nix profile upgrade '.*'` — all Nix packages
4. `nix store gc` — garbage-collect unused Nix store paths
5. Pulls latest Zsh plugins

### `theme-switcher` — Theme Manager

Located at `~/.local/bin/theme-switcher` (symlinked from `scripts/theme-switcher`).

```bash
theme-switcher catppuccin
theme-switcher tokyo-night
theme-switcher dracula
```

---

## Stow Cheatsheet

All commands are run from `~/.dotfiles/`.

```bash
# Stow a single package (creates symlinks)
stow zsh

# Stow all packages at once
stow zsh wezterm starship bat bin

# Re-stow (update existing symlinks)
stow --restow zsh

# Remove symlinks for a package
stow --delete zsh

# Dry run (see what would happen)
stow --simulate zsh
```

---

## Updating the System

```bash
# Full update (apt + Flatpak + Nix + Zsh plugins)
up

# Update Nix packages only
nix profile upgrade '.*'

# Update a specific Nix package
nix profile upgrade nixpkgs#bat

# Clean Nix store
nix store gc
```

---

## Troubleshooting

### Nix not found after installation

```bash
# Source the Nix daemon script
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Or restart your terminal
exec zsh
```

### Fonts not rendering correctly (missing icons)

1. Ensure JetBrainsMono Nerd Font is installed: `fc-list | grep JetBrains`
2. In WezTerm, verify the font: the `.wezterm.lua` uses `"JetBrainsMono Nerd Font"`
3. If icons still appear as boxes, run: `fc-cache -f && fc-cache -r`

### Zsh plugins not loading

```bash
# Verify plugins exist
ls ~/.zsh/plugins/

# Re-clone if missing
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
  ~/.zsh/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.zsh/plugins/zsh-syntax-highlighting
```

### Stow conflicts

If stow reports a conflict (file already exists at target), either delete the
existing file or back it up:

```bash
mv ~/.zshrc ~/.zshrc.bak
stow zsh
```

### Theme not applying to WezTerm

WezTerm reads `~/.config/current-theme` on startup. If already running, the
`theme-switcher` script sends `SIGUSR1` to reload. If that doesn't work:
- Close and reopen WezTerm

### bat theme not found

If bat reports an unknown theme, it may not ship that theme by default. Use a
built-in theme or install custom themes:

```bash
# List available bat themes
bat --list-themes

# Install Catppuccin theme for bat (one-time setup)
mkdir -p "$(bat --config-dir)/themes"
curl -fsSL https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme \
  -o "$(bat --config-dir)/themes/Catppuccin Macchiato.tmTheme"
bat cache --build
```

---

*Built with ❤️ for a macOS-style Ubuntu workflow.*
