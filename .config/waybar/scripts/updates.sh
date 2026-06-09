#!/bin/bash

if ! ping -c 1 1.1.1.1 &>/dev/null; then
    echo "{\"text\": \"󰖪\", \"tooltip\": \"Offline\", \"class\": \"offline\"}"
    exit 0
fi

official=$(timeout 10 checkupdates 2>/dev/null | wc -l)

aur=$(timeout 10 yay -Qua 2>/dev/null | wc -l)

total=$((official + aur))

if [ "$total" -gt 0 ]; then
    echo "{\"text\": \"$total\", \"tooltip\": \"Official: $official\nAUR: $aur\", \"class\": \"has-updates\"}"
else
    echo "{\"text\": \"0\", \"tooltip\": \"System Updated\", \"class\": \"updated\"}"
fi
