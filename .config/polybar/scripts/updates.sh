#!/bin/bash
pac=$(checkupdates | wc -l 2> /dev/null)
aur=$(yay -S | wc -l 2> /dev/null)

check=$((pac + aur))

if [[ "$check" != "0" ]]
then
    echo " $check"
else
    echo " 0"
fi

