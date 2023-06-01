sleep 20s
killall conky
cd "$HOME/.config/conky/Widgets"
conky -q -c "$HOME/.config/conky/Widgets/Main" &
conky -q -c "$HOME/.config/conky/Widgets/Emacs" &
