#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

dotpush() {
    config add -u # Automatically stages all modified tracked files
    config commit -m "${1:-update dotfiles}" # Uses your message, or a      default one
    config push
}
