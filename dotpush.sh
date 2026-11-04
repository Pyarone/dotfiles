#!/bin/bash
#example of adding a file: config add -f ~/.bashrc
#example of removing a file: config rm --cached ~/.bashrc
#--cached means remove from repo without deleting locally
konsole -e bash -c "
    git --git-dir=$HOME/.cfg/ --work-tree=$HOME add -u
    git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit -m 'Auto-sync update: $(date +'%Y-%m-%d %H:%M:%S')'
    git --git-dir=$HOME/.cfg/ --work-tree=$HOME push
    echo
    echo 'Done! Press enter to close.'
    read
"
