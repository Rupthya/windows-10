# Path
PATH="/opt/cmake/bin:/opt/llvm/bin:/opt/java/bin:/opt/emsdk:/opt/binaryen/bin"
PATH="${PATH}:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export PATH

# Limits
ulimit -S -c 0

# User
setenv UID `id -u`

# History
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000
shopt -s histappend

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
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
#export EDITOR=$(which nvim vim vi 2>/dev/null | head -1)
export EDITOR=$(which vim vi 2>/dev/null | head -1)
export PAGER="less"

# Colors
LC_COLORS=
LS_COLORS="${LS_COLORS}di=1;34:"
LS_COLORS="${LS_COLORS}ln=35;40:"
LS_COLORS="${LS_COLORS}so=32;40:"
LS_COLORS="${LS_COLORS}pi=33;40:"
LS_COLORS="${LS_COLORS}ex=31;40:"
LS_COLORS="${LS_COLORS}bd=34;46:"
LS_COLORS="${LS_COLORS}cd=34;43:"
LS_COLORS="${LS_COLORS}su=0;41:"
LS_COLORS="${LS_COLORS}sg=0;46:"
LS_COLORS="${LS_COLORS}tw=0;42:"
LS_COLORS="${LS_COLORS}ow=1;34"
export LS_COLORS

# Aliases
alias ..="cd .."

alias ls="ls -F --color=auto --group-directories-first"
alias lsa="ls -a"

alias ll="ls -lh --time-style long-iso"
alias lla="ll -a"

alias vim="${EDITOR} -p"
alias grep="grep --color=auto"
alias less="less -i -R"
alias sudo="sudo "

alias tm="tmux -2"
alias ta="tm attach -t"
alias ts="tm new-session -s"
alias tl="tm list-sessions"

if [ -d /mnt/c/Windows ]; then
  alias ping="wcmd : ping"
fi

# Settings
export HISTFILE="${HOME}/.history"

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