#!/usr/bin/env bash
# =============================================================================
# UBUNTU 2026 - MODERN INFRASTRUCTURE INSTALLER
# macOS-style workflow on Ubuntu powered by Nix + Stow
# =============================================================================
set -euo pipefail

# ─── Colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${BLUE}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*" >&2; exit 1; }
step()    { echo -e "\n${BOLD}${CYAN}▶ $*${RESET}"; }

# ─── Validation ───────────────────────────────────────────────────────────────
[[ "$(uname -s)" == "Linux" ]] || error "This installer is designed for Linux only."
command -v apt-get &>/dev/null || error "apt-get not found — Debian/Ubuntu required."

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
info "Dotfiles directory: ${DOTFILES_DIR}"

# ─── Step 1: System prerequisites ─────────────────────────────────────────────
step "Installing system prerequisites"
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends \
  curl wget git zsh unzip xz-utils ca-certificates \
  gnupg lsb-release flatpak gnome-software-plugin-flatpak \
  gnome-sushi
success "System prerequisites installed."

# ─── Step 2: Nix (multi-user) ─────────────────────────────────────────────────
step "Installing Nix (multi-user)"
if command -v nix &>/dev/null; then
  warn "Nix already installed — skipping."
else
  curl -fsSL https://install.determinate.systems/nix | \
    sh -s -- install --no-confirm
  # Source Nix environment for the rest of this script
  # shellcheck source=/dev/null
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  success "Nix installed."
fi

# Ensure nix is on PATH for subsequent commands
export PATH="/nix/var/nix/profiles/default/bin:${HOME}/.nix-profile/bin:${PATH}"

# ─── Step 3: Nix packages ─────────────────────────────────────────────────────
step "Installing CLI tools via Nix"
NIX_PACKAGES=(
  nixpkgs#starship
  nixpkgs#bat
  nixpkgs#eza
  nixpkgs#zoxide
  nixpkgs#fzf
  nixpkgs#ripgrep
  nixpkgs#fd
  nixpkgs#delta
  nixpkgs#lazygit
  nixpkgs#stow
  nixpkgs#glow
  nixpkgs#tldr
  nixpkgs#btop
  nixpkgs#thefuck
)

for pkg in "${NIX_PACKAGES[@]}"; do
  info "Installing ${pkg}..."
  nix profile install "${pkg}" 2>/dev/null && success "${pkg} installed." \
    || warn "${pkg} already in profile or install failed — skipping."
done

# ─── Step 4: JetBrainsMono Nerd Font ──────────────────────────────────────────
step "Installing JetBrainsMono Nerd Font"
FONT_DIR="${HOME}/.local/share/fonts"
mkdir -p "${FONT_DIR}"

if fc-list | grep -qi "JetBrainsMono"; then
  warn "JetBrainsMono Nerd Font already installed — skipping."
else
  FONT_VERSION="3.2.1"
  FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VERSION}/JetBrainsMono.zip"
  TMP_FONT=$(mktemp -d)
  info "Downloading JetBrainsMono Nerd Font v${FONT_VERSION}..."
  curl -fsSL "${FONT_URL}" -o "${TMP_FONT}/JetBrainsMono.zip"
  unzip -q "${TMP_FONT}/JetBrainsMono.zip" -d "${TMP_FONT}/fonts"
  cp "${TMP_FONT}/fonts"/*.ttf "${FONT_DIR}/"
  fc-cache -f
  rm -rf "${TMP_FONT}"
  success "JetBrainsMono Nerd Font installed."
fi

# ─── Step 5: Zsh as default shell ─────────────────────────────────────────────
step "Setting Zsh as default shell"
ZSH_PATH="$(command -v zsh)"
if [[ "${SHELL}" == "${ZSH_PATH}" ]]; then
  warn "Zsh is already the default shell — skipping."
else
  if ! grep -qF "${ZSH_PATH}" /etc/shells; then
    echo "${ZSH_PATH}" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "${ZSH_PATH}"
  success "Default shell changed to Zsh (${ZSH_PATH})."
fi

# ─── Step 6: Zsh plugins ──────────────────────────────────────────────────────
step "Installing Zsh plugins"
ZSH_PLUGINS_DIR="${HOME}/.zsh/plugins"
mkdir -p "${ZSH_PLUGINS_DIR}"

_clone_or_update() {
  local name="$1" url="$2" dest="${ZSH_PLUGINS_DIR}/$1"
  if [[ -d "${dest}/.git" ]]; then
    info "${name} already cloned — pulling latest."
    git -C "${dest}" pull --ff-only -q
  else
    info "Cloning ${name}..."
    git clone --depth=1 "${url}" "${dest}"
    success "${name} installed."
  fi
}

_clone_or_update "zsh-autosuggestions" \
  "https://github.com/zsh-users/zsh-autosuggestions"
_clone_or_update "zsh-syntax-highlighting" \
  "https://github.com/zsh-users/zsh-syntax-highlighting"

# ─── Step 7: Stow dotfiles ────────────────────────────────────────────────────
step "Stowing dotfiles with GNU Stow"
STOW_PACKAGES=(zsh wezterm starship bat bin)

cd "${DOTFILES_DIR}"
for pkg in "${STOW_PACKAGES[@]}"; do
  if [[ -d "${pkg}" ]]; then
    info "Stowing ${pkg}..."
    stow --restow --target="${HOME}" "${pkg}"
    success "${pkg} stowed."
  else
    warn "Package '${pkg}' directory not found — skipping."
  fi
done

# ─── Step 8: scripts/ on PATH ────────────────────────────────────────────────
step "Making scripts/ available on PATH"
SCRIPTS_DEST="${HOME}/.local/bin"
mkdir -p "${SCRIPTS_DEST}"

for script in "${DOTFILES_DIR}/scripts/"*; do
  [[ -f "${script}" ]] || continue
  chmod +x "${script}"
  ln -sf "${script}" "${SCRIPTS_DEST}/$(basename "${script}")"
  success "Linked $(basename "${script}") → ${SCRIPTS_DEST}/"
done

# ─── Step 9: Flathub remote ───────────────────────────────────────────────────
step "Adding Flathub Flatpak remote"
if flatpak remotes | grep -q "^flathub"; then
  warn "Flathub already configured — skipping."
else
  flatpak remote-add --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo
  success "Flathub added."
fi

# ─── Step 10: WezTerm via Flatpak ────────────────────────────────────────────
# WezTerm is installed via Flatpak (not Nix) because the Nix package has known
# issues on Wayland sessions.  A user-level .desktop override is also created
# to force XWayland mode (WAYLAND_DISPLAY=""), which avoids rendering/startup
# crashes that occur with some Wayland compositors.
step "Installing WezTerm via Flatpak"
if flatpak list --app | grep -q "org.wezfurlong.wezterm"; then
  warn "WezTerm (Flatpak) already installed — skipping."
else
  flatpak install -y flathub org.wezfurlong.wezterm
  success "WezTerm installed via Flatpak."
fi

# Create a user-level .desktop override so WezTerm launches via XWayland.
# This mirrors the fix of duplicating the system launcher into the user profile
# and prepending 'env WAYLAND_DISPLAY=""' to the Exec line.
WEZTERM_DESKTOP_DIR="${HOME}/.local/share/applications"
WEZTERM_DESKTOP="${WEZTERM_DESKTOP_DIR}/org.wezfurlong.wezterm.desktop"
mkdir -p "${WEZTERM_DESKTOP_DIR}"

# Locate the system-exported desktop file (location varies by install scope)
SYSTEM_DESKTOP=""
for candidate in \
  "/var/lib/flatpak/exports/share/applications/org.wezfurlong.wezterm.desktop" \
  "${HOME}/.local/share/flatpak/exports/share/applications/org.wezfurlong.wezterm.desktop"
do
  [[ -f "${candidate}" ]] && SYSTEM_DESKTOP="${candidate}" && break
done

if [[ -n "${SYSTEM_DESKTOP}" ]]; then
  cp "${SYSTEM_DESKTOP}" "${WEZTERM_DESKTOP}"
  # Prepend 'env WAYLAND_DISPLAY=""' to every Exec= line
  sed -i 's|^Exec=|Exec=env WAYLAND_DISPLAY="" |g' "${WEZTERM_DESKTOP}"
  # Ensure the desktop DB picks up the change
  update-desktop-database "${WEZTERM_DESKTOP_DIR}" 2>/dev/null || true
  success "WezTerm desktop launcher overridden (XWayland forced)."
else
  # Flatpak may not export the .desktop file until the next login (this happens
  # when Flatpak is freshly added to the system scope in the same session).
  # Write a minimal but functional override; Flatpak will merge/supersede it on
  # next desktop-database refresh.  The simplified "flatpak run" form is
  # intentional here — without the system file we don't know the exact arch or
  # branch flags, and plain "flatpak run" will pick the installed variant.
  cat > "${WEZTERM_DESKTOP}" << 'EOF'
[Desktop Entry]
Name=WezTerm
Comment=Wez's Terminal Emulator
Exec=env WAYLAND_DISPLAY="" flatpak run org.wezfurlong.wezterm
Icon=org.wezfurlong.wezterm
Terminal=false
Type=Application
Categories=System;TerminalEmulator;
StartupWMClass=org.wezfurlong.wezterm
EOF
  update-desktop-database "${WEZTERM_DESKTOP_DIR}" 2>/dev/null || true
  success "WezTerm desktop launcher (XWayland override) written."
fi

# ─── Step 11: GNOME Quick Look (gnome-sushi) ──────────────────────────────────
step "Enabling GNOME Sushi Quick Look"
if command -v sushi &>/dev/null || dpkg -l gnome-sushi &>/dev/null 2>&1; then
  info "gnome-sushi is installed."
  info "Usage: Select a file in Nautilus and press the Space bar to preview."
  success "GNOME Quick Look (gnome-sushi) is ready."
else
  warn "gnome-sushi could not be verified; it was requested in apt above."
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}${GREEN}╔══════════════════════════════════════════════╗"
echo -e "║  ✅  Installation complete!                  ║"
echo -e "║  Please restart your terminal / log out.     ║"
echo -e "╚══════════════════════════════════════════════╝${RESET}\n"
info "Next steps:"
echo -e "  1. Log out and back in (or run: exec zsh)"
echo -e "  2. Switch themes:  ${CYAN}theme-switcher catppuccin${RESET}"
echo -e "  3. Update system:  ${CYAN}up${RESET}"
echo -e "  4. Read the manual: ${CYAN}cat README.md | glow${RESET}"
