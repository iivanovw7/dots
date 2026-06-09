#!/bin/bash

# Terminate already running bar instances
killall -q waybar

# Wait until the processes have been shut down
while pgrep -u $UID -x waybar >/dev/null; do sleep 3; done

# Ensure the socket environment variable is set for THIS process
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /run/user/$(id -u)/hypr/ | head -n 1)
fi

# Launch Waybar
waybar &
