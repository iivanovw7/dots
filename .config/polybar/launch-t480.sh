#!/bin/sh

# Terminate already running bar instances
killall -q polybar &
sleep 1

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

source ~/.config/xrandr/t480-laptop-only.sh
sleep 1
feh --bg-fill ~/Backgrounds/desktop.png

MONITOR=eDP-1 polybar --reload primary -c ~/.config/polybar/bar-primary.ini &
MONITOR=eDP-1 polybar --reload primary-bottom -c ~/.config/polybar/bar-primary-bottom.ini

echo "Bars launched..."
