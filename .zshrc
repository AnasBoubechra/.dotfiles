autoload -U colors && colors
#bindkey '^[[3;5~' beginning-of-line
setopt prompt_subst
# Prompt
local smiley="%(?,%{$fg[green]%}>%{$reset_color%},%{$fg[red]%}☹%{$reset_color%})"
PROMPT='
%~${smiley} %{$reset_color%}'
RPROMPT='%{$fg[white]%} %{$reset_color%}'
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

#Make vim the default editor
export EDITOR='vim'
export VISUAL='vim'
# vi mode
bindkey -v
export KEYTIMEOUT=1
# bindkey
# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
cdfzf(){
   cd "$(find ~ -type d | fzf --reverse )"
   zle reset-prompt
 }
zle -N cdfzf
# Open files using xdg and fuzzy search
global_search() {
  xdg-open "$(rg . | fzf --reverse --pointer="->" --prompt="-->: " | sed "s/:.*//")"
      zle reset-prompt
}
zle -N global_search
fuzzy-local() {
  xdg-open "$(find | fzf -e --multi --bind 'ctrl-l:toggle-preview' --bind 'ctrl-k:change-preview-window(down,80%)' --reverse --pointer="->" --prompt="-->: " --preview 'bat -p -f {}')"
      zle reset-prompt
    }
zle -N fuzzy-local
fuzzy-global() {
  xdg-open "$(find ~ -type f |fzf -e --multi --bind 'ctrl-l:toggle-preview' --bind 'ctrl-k:change-preview-window(down,80%)' --reverse --pointer="->" --prompt="-->: " --preview 'bat -p -f {}')"  
      zle reset-prompt
      
}
zle -N fuzzy-global
# Can select multiple processes with <TAB> or <Shift-TAB> keys
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
#Making zsh case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit
# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"

[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
export PATH=/usr/bin/my_scripts:/home/dy/.local/bin:/home/dy/.local/bin/my_scripts:$PATH
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
