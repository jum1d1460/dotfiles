# 📦 GNU Stow — Dotfiles Deployment

GNU Stow is a **symlink farm manager**. It creates symbolic links in `$HOME` that point to files inside your `~/.dotfiles` repository, allowing you to manage all your config files in one version-controlled directory.

---

## How It Works

Each subdirectory in `~/.dotfiles/` is a **Stow package**. When you stow a package, Stow mirrors its internal directory tree by creating symlinks in `$HOME`.

**Example:**

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

## Packages in This Repository

| Package | Source | Target symlinks |
|---------|--------|----------------|
| `zsh` | `zsh/.zshrc` | `~/.zshrc` |
| `wezterm` | `wezterm/.wezterm.lua` | `~/.wezterm.lua` |
| `starship` | `starship/.config/starship.toml` | `~/.config/starship.toml` |
| `bat` | `bat/.config/bat/config` | `~/.config/bat/config` |
| `bin` | `bin/.local/bin/up` | `~/.local/bin/up` |

---

## Common Commands

All Stow commands must be run from `~/.dotfiles/`:

```bash
cd ~/.dotfiles

# Stow a single package (create symlinks)
stow zsh

# Stow multiple packages at once
stow zsh wezterm starship bat bin

# Stow all packages (re-stow = update existing symlinks)
stow --restow zsh wezterm starship bat bin

# Remove symlinks for a package (un-stow)
stow --delete zsh

# Dry run — see what would happen without making changes
stow --simulate zsh
stow --simulate --verbose zsh

# Stow to a custom target directory
stow --target=/custom/path zsh
```

---

## Adding a New Config File to Stow

Suppose you want to manage `~/.config/nvim/init.lua` with Stow:

```bash
cd ~/.dotfiles

# Create the package directory structure
mkdir -p nvim/.config/nvim

# Move the real file into the package
mv ~/.config/nvim/init.lua nvim/.config/nvim/init.lua

# Stow the package (creates the symlink)
stow nvim

# Verify
ls -la ~/.config/nvim/init.lua
# ~/.config/nvim/init.lua -> ~/.dotfiles/nvim/.config/nvim/init.lua
```

---

## Handling Conflicts

If a target file already exists (not a symlink), Stow will refuse to overwrite it:

```
WARNING! stow: existing target is not owned by stow: .zshrc
```

**Fix:**

```bash
# Back up the existing file
mv ~/.zshrc ~/.zshrc.bak

# Stow the package
stow zsh

# Optionally merge any custom settings from the backup into the stowed file
```

---

## Checking Symlink Status

```bash
# Check if a file is a symlink and where it points
ls -la ~/.zshrc
# ~/.zshrc -> /home/user/.dotfiles/zsh/.zshrc

# Check all symlinks in your home config dir
ls -la ~/.config/ | grep "\->"

# Find all symlinks pointing into dotfiles
find ~ -maxdepth 3 -type l 2>/dev/null | xargs -I{} sh -c 'ls -la "{}" 2>/dev/null | grep dotfiles'
```

---

## Why Stow Instead of Manual Symlinks?

| Feature | Manual `ln -sf` | GNU Stow |
|---------|----------------|----------|
| Remove a package | Delete each symlink manually | `stow --delete pkg` |
| Update after adding files | Re-run each `ln` command | `stow --restow pkg` |
| Dry run | Not available | `stow --simulate pkg` |
| Handle nested directories | Manual `mkdir` needed | Automatic |
| One-liner for all packages | Not practical | `stow zsh wezterm bat ...` |
