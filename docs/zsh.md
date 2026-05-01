# 🐚 Zsh — Shell Configuration

Your shell is **Zsh**, configured for maximum productivity with modern plugins, smart history, and a curated set of aliases.

**Config file:** `~/.zshrc` (symlinked from `~/.dotfiles/zsh/.zshrc`)

---

## Plugins

| Plugin | Effect |
|--------|--------|
| `zsh-autosuggestions` | Grey ghost text shows history suggestions as you type. Press `→` or `End` to accept. |
| `zsh-syntax-highlighting` | Commands turn green when valid, red when not found, while you type. |

Both plugins are cloned to `~/.zsh/plugins/` during installation.

---

## Shell Options

| Option | Effect |
|--------|--------|
| `AUTO_CD` | Type a directory name to `cd` into it (no `cd` needed) |
| `AUTO_PUSHD` | Every `cd` pushes the old dir onto a stack (`popd` to go back) |
| `CORRECT` | Suggests corrections for mistyped commands |
| `INTERACTIVE_COMMENTS` | You can type `# comments` in the interactive shell |

---

## History

| Setting | Value |
|---------|-------|
| History size | 1,000,000 entries |
| Saved to disk | `~/.zsh_history` |
| Shared across sessions | ✅ (all open terminals share history) |
| Timestamps stored | ✅ |
| Duplicates removed | ✅ |
| Written immediately | ✅ (not just at shell exit) |

---

## Tab Completion

- Press `Tab` to complete commands, paths, and arguments
- Press `Tab Tab` to open an interactive menu
- Use arrow keys to navigate the menu
- Completion is **case-insensitive** by default
- Completion menu inherits your `LS_COLORS` colours

---

## Keyboard Shortcuts

### fzf Integration

| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | **Fuzzy history search** — find any past command |
| `Ctrl+T` | **Fuzzy file picker** — select a file, paste its path |
| `Alt+C` | **Fuzzy directory picker** — `cd` into selected dir |

### Standard Zsh

| Shortcut | Action |
|----------|--------|
| `Ctrl+A` | Move cursor to beginning of line |
| `Ctrl+E` | Move cursor to end of line |
| `Ctrl+W` | Delete word before cursor |
| `Ctrl+U` | Delete entire line |
| `Ctrl+K` | Delete from cursor to end of line |
| `Ctrl+L` | Clear screen |
| `Ctrl+C` | Cancel current command |
| `Ctrl+Z` | Suspend current process (resume with `fg`) |
| `Alt+F` | Move forward one word |
| `Alt+B` | Move backward one word |

---

## Aliases — File Operations

| Alias | Expands to | Notes |
|-------|-----------|-------|
| `cat` | `bat --paging=never` | Syntax-highlighted file view |
| `less` | `bat --paging=always` | Scrollable syntax-highlighted view |
| `ls` | `eza --icons --group-directories-first` | Icons, dirs first |
| `ll` | `eza --icons --long --group-directories-first --git` | Long format with Git |
| `la` | `eza --icons --long --all --group-directories-first --git` | Include hidden |
| `lt` | `eza --icons --tree --level=2 --group-directories-first` | Tree view |
| `lta` | `eza --icons --tree --level=2 --all --group-directories-first` | Tree + hidden |
| `mkdir` | `mkdir -p` | Create parent dirs automatically |
| `cp` | `cp -i` | Prompt before overwriting |
| `mv` | `mv -i` | Prompt before overwriting |
| `rm` | `rm -i` | Prompt before deleting |
| `grep` | `grep --color=auto` | Always colorize matches |

---

## Aliases — Navigation

| Alias | Expands to |
|-------|-----------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |

---

## Aliases — System

| Alias | Expands to | Notes |
|-------|-----------|-------|
| `top` | `btop` | Graphical process monitor |
| `df` | `df -h` | Human-readable disk usage |
| `du` | `du -h` | Human-readable dir sizes |
| `free` | `free -h` | Human-readable memory |
| `ps` | `ps auxf` | Full process tree |
| `reload` | `source ~/.zshrc` | Reload Zsh config |
| `help` | `tldr` | Quick command examples |

---

## Aliases — Git

| Alias | Expands to |
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
| `gl` | `git log` (graphical, coloured, all branches) |
| `gd` | `git diff` (via delta) |
| `gds` | `git diff --staged` (via delta) |
| `grb` | `git rebase` |
| `gst` | `git stash` |
| `gstp` | `git stash pop` |
| `lg` | `lazygit` (TUI git client) |

---

## Environment Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| `EDITOR` | `vim` | Default editor (used by git, cron, etc.) |
| `VISUAL` | same as `EDITOR` | GUI editor fallback |
| `BAT_STYLE` | `numbers,changes,header` | bat decoration style |
| `BAT_THEME` | `Catppuccin Macchiato` (default) | bat colour theme |
| `GIT_PAGER` | `delta` | git diffs routed through delta |
| `MANPAGER` | `bat -l man` | man pages rendered by bat |
| `FZF_DEFAULT_COMMAND` | `fd --type f ...` | fzf uses fd for file search |
| `PATH` | `~/.local/bin`, `~/.nix-profile/bin`, ... | Tool search paths |

---

## Modifying the Configuration

```bash
# Edit the config in the dotfiles repo
vim ~/.dotfiles/zsh/.zshrc

# Apply changes to current session
reload   # alias for: source ~/.zshrc

# Or open a new terminal tab
```

> **Note:** Always edit `~/.dotfiles/zsh/.zshrc`, not `~/.zshrc` directly.  
> `~/.zshrc` is a symlink managed by Stow — editing it directly works too (it's the same file), but keeping edits in `~/.dotfiles` makes them version-controlled.

---

## Checking Plugin Status

```bash
# Verify plugins are loaded
echo $ZSH_AUTOSUGGESTIONS_VERSION   # should print a version
echo $ZSH_HIGHLIGHT_VERSION         # should print a version

# Or check the plugin files exist
ls ~/.zsh/plugins/
```
