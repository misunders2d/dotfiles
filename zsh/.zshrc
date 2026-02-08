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


export GOOGLE_CLOUD_PROJECT=mellanni-agent

alias ll="ls -la"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
