# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Oh My Zsh framework
source /usr/share/oh-my-zsh/oh-my-zsh.sh

# Load plugins manually
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Load theme manually
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Created by newuser for 5.9
autoload -Uz compinit promptinit
compinit
promptinit

zstyle ':completion:*' menu select


# export GOOGLE_CLOUD_PROJECT=mellanni-agent

alias ll="ls -la"
alias vial='env QT_SCALE_FACTOR=1.5 QT_QPA_PLATFORMTHEME=qt6ct QT_AUTO_SCREEN_SCALE_FACTOR=1 QT_ENABLE_HIGHDPI_SCALING=1 DESKTOPINTEGRATION=false /usr/bin/Vial'

# Launch Pi with Infisical-injected production secrets.
# Run `cd ~ && infisical init` once, or set INFISICAL_PROJECT_ID.
_pi_infisical_update_notice() {
  local cache="$HOME/.infisical/update-check.json"
  local pkg current latest updater

  [[ -r "$cache" ]] || return 0

  if pacman -Q infisical-bin >/dev/null 2>&1; then
    pkg="infisical-bin"
  elif pacman -Q infisical >/dev/null 2>&1; then
    pkg="infisical"
  else
    return 0
  fi

  current=$(pacman -Q "$pkg" 2>/dev/null | awk '{print $2}' | sed 's/-[0-9][0-9]*$//')
  latest=$(python - "$cache" <<'PY' 2>/dev/null
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    print(json.load(f).get("latestVersion", ""))
PY
)

  [[ -n "$current" && -n "$latest" && "$current" != "$latest" ]] || return 0

  # Only warn when installed is strictly older than latest. The cache can lag
  # behind the distro package (e.g. installed 0.43.99 vs cached latest 0.43.97),
  # which would otherwise suggest a bogus downgrade.
  printf '%s\n%s\n' "$current" "$latest" | sort -V -C || return 0

  if command -v yay >/dev/null 2>&1; then
    updater="yay -Syu"
  elif command -v paru >/dev/null 2>&1; then
    updater="paru -Syu"
  else
    updater="AUR helper update needed for"
  fi

  print -P "%F{yellow}A new release of infisical is available: %F{cyan}${current}%f %F{yellow}->%f %F{cyan}${latest}%f"
  print "To update, run: ${updater} ${pkg}"
}

pi() {
  local infisical_env="${INFISICAL_ENV:-prod}"
  local pi_bin="$HOME/.pi/agent/bin/pi"
  _pi_infisical_update_notice
  if [[ -n "$INFISICAL_PROJECT_ID" ]]; then
    infisical --silent run --env="$infisical_env" --path=/ --recursive --projectId="$INFISICAL_PROJECT_ID" -- "$pi_bin" "$@"
  else
    infisical --silent run --env="$infisical_env" --path=/ --recursive --project-config-dir="$HOME" -- "$pi_bin" "$@"
  fi
}

alias pi-raw="/usr/bin/pi"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export EDITOR='nvim'
export VISUAL='nvim'
export PATH="$HOME/.local/bin:$PATH"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="$HOME/.local/bin:$PATH"

# Load local secrets (untracked, see ~/.zshrc.local)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local


# Added by Antigravity CLI installer
export PATH="/home/misunderstood/.local/bin:$PATH"
