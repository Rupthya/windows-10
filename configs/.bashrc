# Path
PATH="/opt/cmake/bin:/opt/llvm/bin:/opt/emsdk:/opt/binaryen/bin:/opt/java/bin"
PATH="${PATH}:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export PATH

# Limits
ulimit -S -c 0

# Unicode
export UTF8=$(locale -m | grep -i utf | head -1)
export NCURSES_NO_UTF8_ACS="1"
export MM_CHARSET="UTF-8"

# Localization
export LANG="en_US.${UTF8}"
export LC_MESSAGES="en_US.${UTF8}"
export LC_CTYPE="en_US.${UTF8}"
export LC_COLLATE="C"
export LC_ALL=

# Applications
export NODE_PATH="/usr/local/lib/node_modules"
export EDITOR="$(which vim vi 2>/dev/null | head -1)"
export PAGER="less"

# Colors
export CLICOLOR=1
export LSCOLORS="ExGxFxdxCxDxDxBxAbBxFx"
export LS_COLORS="di=1;34:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=1;34"

# Aliases
alias ..="cd .."

if [ "$(uname -s)" = "Darwin" ]; then
  alias ls="ls -FG"
  alias ll="ls -lh"
else
  alias ls="ls -F --color=auto --group-directories-first"
  alias ll="ls -lh --time-style long-iso"
fi

alias lsa="ls -a"
alias lla="ll -a"

alias vim="${EDITOR} -p"
alias vimdiff="${EDITOR} -d"
alias grep="grep --color=auto"
alias sudo="sudo "

alias tm="tmux -2"
alias ta="tm attach -t"
alias ts="tm new-session -s"
alias tl="tm list-sessions"

# Settings
export HISTFILE="${HOME}/.history"
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000
shopt -s histappend

PS1=
if [ -n "${TMUX}" ]; then
  id="$(echo $TMUX | awk -F, '{print $3 + 1}')"
  session="$(tmux ls | head -${id} | tail -1 | cut -d: -f1)"
  PS1="${PS1}\[\e[90m\][\[\e[0m\]${session}\[\e[90m\]]\[\e[0m\] "
fi
if [ $(id -u) -ne 0 ]; then
  PS1="${PS1}\[\e[32m\]\u\[\e[0m\]"
else
  PS1="${PS1}\[\e[31m\]\u\[\e[0m\]"
fi
PS1="${PS1}@\[\e[32m\]\h\[\e[0m\]"
PS1="${PS1} \[\e[34m\]\w\[\e[0m\] "
export PS1

set -o emacs
