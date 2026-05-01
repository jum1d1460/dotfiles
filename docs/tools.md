# 🛠️ CLI Tools Reference

All tools are installed via **Nix** and available immediately after running `install.sh`.

---

## Quick Replacement Map

| Classic | Modern | Why upgrade? |
|---------|--------|-------------|
| `cat` | `bat` | Syntax highlighting, line numbers, Git change markers |
| `ls` | `eza` | Icons, Git status, tree view, colour-coded types |
| `find` | `fd` | Simpler syntax, much faster, respects `.gitignore` |
| `grep` | `rg` | Much faster, respects `.gitignore`, better defaults |
| `cd` | `cd` (zoxide) | Learns your habits — fuzzy jump to frequent dirs |
| `top` | `btop` | Graphical, mouse-driven, shows GPU/net/disk |
| `man` | `man` (via bat) | Syntax-highlighted man pages |
| `--help` | `tldr` | Concise, practical examples |

---

## bat — File Viewer with Syntax Highlighting

**What it is:** `cat` replacement with syntax highlighting, line numbers, and Git change markers.

```bash
bat file.py              # view file with syntax highlighting
bat -n file.py           # line numbers only, no other decorations
bat --theme=Dracula file.py   # use a specific theme
bat --list-themes        # list all available themes
bat -l json file.txt     # force JSON syntax highlighting
bat -A file.txt          # show non-printable characters
bat -r 1:50 file.py      # show only lines 1–50
```

**Config file:** `~/.config/bat/config`  
**Current theme:** managed by `theme-switcher` (default: Catppuccin Macchiato)

> **Tip:** `bat` is aliased as `cat` in your shell. Just use `cat` as normal to get syntax highlighting automatically. Use `\cat` to bypass the alias.

---

## eza — Modern ls Replacement

**What it is:** `ls` replacement with icons, Git status, colour-coded types, and tree view.

```bash
ls                       # basic listing (aliased to eza with icons)
ll                       # long format with Git status
la                       # long format, show hidden files
lt                       # tree view (2 levels deep)
lta                      # tree view with hidden files

eza --long --git --icons          # detailed with Git status
eza --tree --level=3              # tree, 3 levels deep
eza --long --sort=modified        # sort by modification date
eza --long --sort=size            # sort by size (largest last)
eza -1                            # one file per line
eza --group-directories-first     # directories at the top
```

**Git status column:** shows `M` (modified), `N` (new), `D` (deleted) next to tracked files.

---

## fd — Fast File Finder

**What it is:** `find` replacement — simpler syntax, much faster, respects `.gitignore`.

```bash
fd pattern               # find files matching pattern (recursive from .)
fd -e py                 # find files with .py extension
fd -t d images           # find directories named "images"
fd -t f -e md            # find Markdown files specifically
fd -H pattern            # include hidden files
fd -I pattern            # ignore .gitignore rules
fd --max-depth 2 config  # search only 2 levels deep
fd pattern ~/projects    # search in a specific directory
fd -x bat {}             # run bat on each result (parallel exec)
```

> **Tip:** `fd` is used by `fzf` internally (see FZF_DEFAULT_COMMAND in your `.zshrc`).

---

## rg (ripgrep) — Fast Text Search

**What it is:** `grep` replacement — much faster, respects `.gitignore`, great defaults.

```bash
rg TODO                  # search for TODO in all files (recursive)
rg "function foo"        # search for exact phrase
rg -i todo               # case-insensitive search
rg -l pattern            # show only filenames (not matching lines)
rg -c pattern            # count matches per file
rg -t py pattern         # search only in Python files
rg -e pattern1 -e p2     # multiple patterns (OR)
rg --no-ignore pattern   # ignore .gitignore rules
rg pattern ~/projects    # search in a specific directory
rg -A3 -B3 pattern       # show 3 lines context before and after
rg -w word               # match whole words only
rg --hidden pattern      # include hidden files
```

---

## fzf — Fuzzy Finder

**What it is:** Interactive fuzzy finder for files, history, and anything else.

### Keyboard shortcuts (always available in your shell)

| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy file picker (pastes path to command line) |
| `Alt+C` | Fuzzy directory picker (`cd` into selection) |

### Using fzf directly

```bash
fzf                      # interactive file picker
vim $(fzf)               # open selected file in vim
fzf --preview 'bat --color=always {}'    # with syntax preview
fzf --multi              # select multiple files with Tab
fzf -q "config"          # pre-fill search query

# Pipe anything into fzf
git branch | fzf         # pick a git branch
cat /etc/hosts | fzf     # filter /etc/hosts lines
ls | fzf                 # pick a file from current dir

# Combined pipeline
git checkout $(git branch | fzf)   # interactive branch switch
```

> **Preview pane:** Your `FZF_DEFAULT_OPTS` already configures a `bat`-powered preview on the right. Press `Ctrl+/` to toggle it.

---

## zoxide — Smart cd

**What it is:** `cd` replacement that learns your navigation habits and lets you jump to directories by partial name.

```bash
cd projects              # jumps to best matching dir you've visited
cd proj/my               # partial path match
cd -                     # go to previous directory (standard)
zi                       # interactive picker of visited dirs (with fzf)
```

> **How it works:** Every `cd` command is recorded. `zoxide` scores directories by frequency and recency and jumps to the best match. The more you use a directory, the easier it is to jump to.

> **Note:** `zoxide` is transparently aliased as `cd`, so no change to your existing muscle memory.

---

## delta — Enhanced Git Diffs

**What it is:** A diff viewer for Git with side-by-side diffs, syntax highlighting, and line numbers. It replaces Git's built-in pager automatically.

```bash
git diff                 # automatically uses delta
git diff --staged        # staged changes, also via delta
git log -p               # commit history with diffs
git show HEAD            # show last commit, rendered by delta
gd                       # alias: git diff via delta
gds                      # alias: git diff --staged via delta
```

> **No configuration needed** — delta is set as your `GIT_PAGER` in `.zshrc`. All `git diff` commands automatically go through it.

---

## lazygit — TUI Git Client

**What it is:** Full-featured terminal UI for Git — stage files, commit, merge, rebase, browse history, all without leaving the terminal.

```bash
lg                       # open lazygit (alias)
lazygit                  # same, without alias
```

### Key bindings inside lazygit

| Key | Action |
|-----|--------|
| ↑ ↓ | Navigate files / commits |
| `Space` | Stage / unstage file |
| `c` | Commit staged changes |
| `p` | Push |
| `P` | Pull |
| `b` | Branch menu |
| `m` | Merge |
| `r` | Rebase |
| `z` | Undo last action |
| `?` | Show all key bindings |
| `q` | Quit |

---

## btop — System Monitor

**What it is:** Graphical, mouse-driven system monitor showing CPU, memory, network, disk, and processes.

```bash
top                      # aliased to btop
btop                     # direct call
```

### Inside btop

| Key | Action |
|-----|--------|
| `F1` or `?` | Help |
| `F2` | Settings |
| `↑ ↓` | Navigate processes |
| `k` | Kill selected process |
| `f` | Filter processes |
| `q` | Quit |
| Mouse | Click to interact with any panel |

---

## tldr — Practical Command Examples

**What it is:** Simplified man pages with practical examples instead of full technical documentation.

```bash
tldr git                 # examples for git
tldr tar                 # how to use tar without googling
tldr fd                  # fd examples
tldr curl                # curl examples
tldr --list              # list all available pages
tldr --update            # update the local cache
```

> **Tip:** `alias help='tldr'` is set in your `.zshrc`. You can run `help git` as a shortcut.

---

## thefuck — Command Corrector

**What it is:** Automatically corrects your last mistyped command. Just type `fuck` after a mistake.

```bash
git comit -m "msg"       # typo!
fuck                     # → runs: git commit -m "msg"

apt-get install vim      # forgot sudo
fuck                     # → runs: sudo apt-get install vim

gti status               # typo for git
fuck                     # → runs: git status
```

> **How it works:** `thefuck --alias` is evaluated in your `.zshrc`, which sets up the `fuck` command. It analyses the previous command's error and suggests the most likely fix.

---

## glow — Markdown Renderer

**What it is:** Beautiful Markdown rendering in the terminal, with an interactive TUI for browsing multiple files.

```bash
glow README.md           # render a Markdown file
glow -p README.md        # render in pager (scrollable, press q to exit)
glow .                   # browse all .md files in current dir (TUI)
glow ~/path/to/docs/     # browse a docs directory interactively
glow https://...         # render remote Markdown (URL)
```

### Inside glow TUI

| Key | Action |
|-----|--------|
| ↑ ↓ | Navigate files |
| `Enter` | Open file |
| `Esc` | Go back |
| `/` | Search |
| `q` | Quit |

> **Tip:** This documentation system uses `glow`. Run `docs` to open it.

---

## starship — Shell Prompt

**What it is:** A minimal, fast, and highly configurable shell prompt that shows useful context (directory, git branch, command duration).

```bash
# No direct commands — it's your prompt.
# Config file: ~/.config/starship.toml

starship explain         # explain every segment in the current prompt
starship timings         # show how long each module takes to render
starship bug-report      # generate a bug report
```

**Prompt segments:**

```
~/projects/my-app  main ⇡2 !  took 3s
❯
```

| Segment | Meaning |
|---------|---------|
| `~/projects/my-app` | Current directory (truncated) |
| ` main` | Git branch name |
| `⇡2` | 2 commits ahead of remote |
| `!` | Uncommitted modifications |
| `took 3s` | Last command took 3 seconds |
| `❯` (green) | Last command succeeded |
| `❯` (red) | Last command failed |
