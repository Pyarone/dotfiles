#!/bin/bash
konsole -e bash -c "
    git --git-dir=$HOME/.cfg/ --work-tree=$HOME pull
    echo
    echo 'Done! Press enter to close.'
    read
"
