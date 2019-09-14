#!/bin/bash

userresources=${HOME}/.Xresources
usermodmap=${HOME}/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Merge ~/.Xresources for sweet urxvt love
#[[ -s ${sysmodmap} ]] && xmodmap ${sysmodmap}
#[[ -s ${sysresources} ]] && xrdb -merge ${sysresource}
[[ -f $HOME/.Xresources ]] && xrdb -merge ${userresources}
[[ -f $HOME/.Xmodmap ]] && xmodmap ${usermodmap}
[[ -f $HOME/.xsessionrc ]] && . ${HOME}/.xsessionrc

# Remap caps lock to control
setxkbmap -layout us -option ctrl:nocaps

# Remap alt and windows key (emulate mac keyboard)
setxkbmap -option altwin:swap_alt_win 

# Requires Nitrogen
nitrogen --restore &
exec i3 -c /home/rawrus/.i3/config -V >> ~/.i3/i3log 2>&1
