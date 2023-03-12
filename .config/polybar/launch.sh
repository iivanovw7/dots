#!/bin/sh

# Terminate already running bar instances
killall -q polybar & sleep 1;

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

xrandr --output eDP1 --primary & sleep 1;

desktop=$(echo $DESKTOP_SESSION)

case $desktop in
  i3)
  if type "xrandr" > /dev/null; then
    outputs=$(xrandr --query | grep " connected" | cut -d" " -f1)

    if wc -w <<< $output == 1
    then
      MONIddTOR=$m polybar --reload primary -c ~/.config/polybar/bar-primary.ini &
      MONITOR=$m polybar --reload primary-bottom -c ~/.config/polybar/bar-primary-bottom.ini &
    else
      xrandr --output DP2-1 --auto --right-of eDP1 &

      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        if [ $m == "eDP1" ]
        then
          MONITOR=$m polybar --reload primary -c ~/.config/polybar/bar-primary.ini &
          MONITOR=$m polybar --reload primary-bottom -c ~/.config/polybar/bar-primary-bottom.ini &
        elif [ $m == "DP2-1" ]
        then
          MONITOR=$m polybar --reload secondary -c ~/.config/polybar/bar-secondary.ini &
        fi
      done
    fi
  fi
  ;;
esac

# Launch bar1 and bar2
# MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)

# polybar top & sleep 10 & polybar bottom;

echo "Bars launched..."
