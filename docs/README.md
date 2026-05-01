# 📚 Dotfiles — Índice de Documentación

Bienvenido al sistema de ayuda interactivo para tu **Infraestructura de Terminal Moderna Ubuntu 2026**.

Navega con las flechas ↑ ↓, pulsa **Enter** para abrir una guía y **Esc** para volver.

---

## Guías Disponibles

| Archivo | Contenido |
|---------|-----------|
| `tools.md` | Todas las herramientas CLI — qué hacen y cómo usarlas |
| `wezterm.md` | Emulador de terminal WezTerm — configuración y atajos de teclado |
| `zsh.md` | Shell Zsh — configuración, alias, plugins y atajos de teclado |
| `themes.md` | Sistema de temas — cómo cambiar y crear temas |
| `scripts.md` | Scripts: `up` (actualizador), `theme-switcher`, `docs` |
| `stow.md` | GNU Stow — cómo se despliegan los dotfiles como enlaces simbólicos |
| `troubleshooting.md` | Problemas habituales y sus soluciones |

---

## Referencia Rápida

```bash
docs                        # abrir este navegador de documentación
docs tools                  # abrir una guía específica directamente
theme-switcher catppuccin   # cambiar al tema Catppuccin
up                          # actualización completa del sistema (apt + Flatpak + Nix)
lg                          # abrir lazygit (cliente Git en TUI)
tldr <comando>              # ejemplos prácticos de cualquier comando
```

---

## Instalación Rápida

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
exec zsh
```

---

*Hecho con ❤️ para un flujo de trabajo Ubuntu al estilo macOS. Desarrollado con Nix + Stow + Zsh.*
