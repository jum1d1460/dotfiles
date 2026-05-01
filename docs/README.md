# 📚 Dotfiles — Documentation Index

Welcome to the interactive help system for your **Ubuntu 2026 Modern Terminal Infrastructure**.

Navigate with ↑ ↓ arrows, press **Enter** to open a doc, **Esc** to go back.

---

## Available Guides

| File | Contents |
|------|----------|
| `tools.md` | All CLI tools — what they do and how to use them |
| `wezterm.md` | WezTerm terminal emulator — config and key bindings |
| `zsh.md` | Zsh shell — config, aliases, plugins, keyboard shortcuts |
| `themes.md` | Theme system — switching and creating themes |
| `scripts.md` | Scripts: `up` (updater), `theme-switcher`, `docs` |
| `stow.md` | GNU Stow — how dotfiles are deployed as symlinks |
| `troubleshooting.md` | Common problems and their fixes |

---

## Quick Reference

```bash
docs                  # open this documentation browser
docs tools            # open a specific doc directly
theme-switcher catppuccin   # switch to Catppuccin theme
up                    # full system update (apt + Flatpak + Nix)
lg                    # open lazygit (TUI git client)
tldr <command>        # practical examples for any command
```

---

## Installation Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
exec zsh
```

---

*Built with ❤️ for a macOS-style Ubuntu workflow. Powered by Nix + Stow + Zsh.*
