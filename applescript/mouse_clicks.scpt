#!/usr/bin/env osascript
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Nho Luong
#  Date: 2022-12-05 16:30:05 +0000 (Mon, 05 Dec 2022)
#
#  https://github.com/nholuongut/devops-bash-tools
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#


# Click N times at coordinates x,y
#
# waits 5 seconds before starting
#
# easier to just use 'MouseTools -leftClick' command line, see adjacent mouse_clicks.sh

# Incomplete, doesn't seem to work, use adjacent mouse_clicks.sh instead which works nicely


set N to 10

# see adjacent get_mouse_coordinates.scpt for how to get the mouse coordinates
set x to 2455
set y to 1273

do shell script "echo waiting 5 secs before starting clicking"
delay 5

# repeat N times
# want loop iterator variable to print the click we're on
set i to 0
repeat while i < N
    tell application "System Events"
        click at {x,y}
    end tell
    #do shell script "echo click " & i
    #copy "click " & i to stdout
    set i to i + 1
    delay 1
end repeat

# looks like last thing printed overwrites all previous output :-/
copy "DONE" to stdout
