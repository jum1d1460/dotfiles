# =============================================================================
# ~/.zshrc — Modern Zsh Configuration
# Designed for Ubuntu 2026 with Nix-managed tooling
# =============================================================================

# ─── Path ─────────────────────────────────────────────────────────────────────
export PATH="${HOME}/.local/bin:${HOME}/bin:${PATH}"
export PATH="${HOME}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${PATH}"

# ─── History ──────────────────────────────────────────────────────────────────
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries first
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks
setopt INC_APPEND_HISTORY     # Write to history immediately
setopt SHARE_HISTORY          # Share history across sessions
setopt EXTENDED_HISTORY       # Save timestamp + duration

# ─── Completion ───────────────────────────────────────────────────────────────
autoload -Uz compinit
# Regenerate .zcompdump once per day
if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ─── Zsh options ──────────────────────────────────────────────────────────────
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push dirs to stack automatically
setopt PUSHD_IGNORE_DUPS    # No duplicate dirs in stack
setopt CORRECT              # Correct minor typos
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell

# ─── Plugins ──────────────────────────────────────────────────────────────────
ZSH_PLUGINS="${HOME}/.zsh/plugins"

# zsh-autosuggestions
[[ -f "${ZSH_PLUGINS}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "${ZSH_PLUGINS}/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-syntax-highlighting (must be last)
[[ -f "${ZSH_PLUGINS}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "${ZSH_PLUGINS}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ─── fzf ──────────────────────────────────────────────────────────────────────
# Use fd as the default find command for fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Preview with bat, directory with eza
export FZF_DEFAULT_OPTS="
  --height=50%
  --layout=reverse
  --border=rounded
  --info=inline
  --preview='([[ -d {} ]] && eza --tree --color=always {} || bat --color=always --line-range=:300 {}) 2>/dev/null'
  --preview-window=right:55%:wrap
  --bind='ctrl-/:toggle-preview'
"

# fzf key bindings & completion
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
fi

# ─── zoxide ───────────────────────────────────────────────────────────────────
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# ─── Starship prompt ──────────────────────────────────────────────────────────
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# ─── thefuck ──────────────────────────────────────────────────────────────────
if command -v thefuck &>/dev/null; then
  eval "$(thefuck --alias)"
fi

# ─── Modern replacements ──────────────────────────────────────────────────────
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias less='bat --paging=always'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza --icons --long --group-directories-first --git'
  alias la='eza --icons --long --all --group-directories-first --git'
  alias lt='eza --icons --tree --level=2 --group-directories-first'
  alias lta='eza --icons --tree --level=2 --all --group-directories-first'
fi

# ─── Git aliases ──────────────────────────────────────────────────────────────
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch --all --prune'
alias gb='git branch'
alias gco='git checkout'
alias gsw='git switch'
alias gl='git log --graph --topo-order --pretty=format:"%C(bold blue)%h%Creset %C(bold green)(%ar)%Creset %s %C(bold yellow)%d%Creset %C(bold white)— %an%Creset" --all'
alias gd='git diff'
alias gds='git diff --staged'
alias grb='git rebase'
alias gst='git stash'
alias gstp='git stash pop'

# Use delta for git diffs if available
if command -v delta &>/dev/null; then
  export GIT_PAGER="delta"
fi

# ─── Lazygit ──────────────────────────────────────────────────────────────────
alias lg='lazygit'

# ─── Utilities ────────────────────────────────────────────────────────────────
alias grep='grep --color=auto'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias top='btop'
alias reload='source ~/.zshrc'

# ─── Editor ───────────────────────────────────────────────────────────────────
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-$EDITOR}"

# ─── bat configuration ────────────────────────────────────────────────────────
export BAT_STYLE="numbers,changes,header"
# BAT_THEME is set by theme-switcher; default here:
export BAT_THEME="${BAT_THEME:-Catppuccin Macchiato}"

# ─── tldr ─────────────────────────────────────────────────────────────────────
alias help='tldr'

# ─── Dotfiles documentation ───────────────────────────────────────────────────
# Location of the dotfiles repo (default: ~/.dotfiles — adjust if cloned elsewhere,
# or override at any time: DOTFILES_DIR=/my/path docs)
export DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/.dotfiles}"
# 'docs' opens the interactive documentation browser (powered by glow)
# Usage: docs           → interactive browser
#        docs <name>    → open specific doc (e.g. docs tools, docs wezterm)
alias docs='glow "${DOTFILES_DIR}/docs/"'

# ─── System info ──────────────────────────────────────────────────────────────
# Print a short system summary on new terminals (optional)
# command -v fastfetch &>/dev/null && fastfetch --logo-type kitty
