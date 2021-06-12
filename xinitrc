#!/bin/sh

export XDG_SESSION_TYPE=x11

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
  xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

export PATH="$PATH:$HOME/p/i3:$HOME/p/i3/build"

setxkbmap it -option 'caps:ctrl_modifier'
xset r rate 200 40
xinput set-prop 'UNIW0001:00 093A:0255 Touchpad' 'libinput Tapping Enabled' 1
xinput set-prop 'UNIW0001:00 093A:0255 Touchpad' 'libinput Natural Scrolling Enabled' 1
xinput set-prop 'UNIW0001:00 093A:0255 Touchpad' 'libinput Accel Profile Enabled' 0 1
xinput set-prop 'UNIW0001:00 093A:0255 Touchpad' 'libinput Accel Speed' 1
xset s noblank
xset s 120 0
if [ "$HOSTNAME" = magnum ]; then
  xrandr --setprovideroutputsource NVIDIA-G0 Intel
  xrandr --auto
  xrandr --output eDP2 --mode 1920x1080 -r 60.01
fi

~/.config/i3/config.sh
i3 -d all --shmlog-size=26214400 2>&1 > .i3logs
