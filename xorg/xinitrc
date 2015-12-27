if [ -s ~/.Xmodmap ]; then
	xmodmap ~/.Xmodmap;
fi

if [ ! -e ~/.i3 ]; then
	mkdir ~/.i3
fi

# Merge ~/.Xresources for sweet urxvt love
[[ -s $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources


# Requires Nitrogen
nitrogen --restore &
exec i3 -V >> ~/.i3/i3log 2>&1
