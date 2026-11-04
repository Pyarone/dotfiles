#!/bin/bash
konsole -e bash -c "
    git --git-dir=$HOME/.cfg/ --work-tree=$HOME pull
    echo
    echo 'Done! Press enter to close.'
    read
"

#if there have been local changes and you want to discard them,
#this is what i would try first:
#config fetch origin
#config reset --hard origin/main
#if the alias from .bashrc is unavailable,
#replace config with git --git-dir=$HOME/.cfg/ --work-tree=$HOME
