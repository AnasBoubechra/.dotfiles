#!/bin/sh
userresources=$HOME/.Xresources
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi
run() 
{
    if ! pgrep $1 ; 
    then 
        $@&
    fi
}
sxhkd -c ~/.config/sxhkd/sxhkdrc &
unclutter &
speedup_cursor &
picom &
slstatus &
run "ufw" &
setbg /home/dy/pic/wallpapers &
run clipmenud &
run redshift &
run dunst &

exec dwm
