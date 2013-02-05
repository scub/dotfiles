if [ ! -e ~/.i3 ]; then
	mkdir ~/.i3
fi


sh feh --bg-scale /usr/share/images/lionsGate.jpg &
exec i3 -V >> ~/.i3/i3log 2>&1
