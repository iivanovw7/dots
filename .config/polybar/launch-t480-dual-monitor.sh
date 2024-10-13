#!/bin/sh

# Terminate already running bar instances
killall -q polybar &
sleep 1

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

source ~/.config/xrandr/t480-dual-monitor.sh
feh --bg-fill ~/Backgrounds/desktop.png

MONITOR=DVI-I-2-2 polybar --reload primary -c ~/.config/polybar/bar-primary.ini &
MONITOR=DVI-I-2-2 polybar --reload primary-bottom -c ~/.config/polybar/bar-primary-bottom.ini &
MONITOR=DVI-I-1-1 polybar --reload secondary -c ~/.config/polybar/bar-secondary.ini

echo "Bars launched..."
