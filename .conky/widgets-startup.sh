sleep 20s
killall conky
cd "/home/iivanovw7/.conky/Widgets"
conky -q -c "/home/iivanovw7/.conky/Widgets/Main" &
conky -q -c "/home/iivanovw7/.conky/Widgets/Emacs" &
