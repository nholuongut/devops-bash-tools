#!/usr/bin/env osascript
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Nho Luong
#  Date: 2020-06-13 20:43:57 +0100 (Sat, 13 Jun 2020)
#
#  https://github.com/nholuongut/devops-bash-tools

#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#

# Gets the coordinates of the mouse cursor
#
# other options:
#
# Cmd-Shift-4   - to take a select area screenshot displays the coordates, then press Esc to cancel
#
# MouseTools -location

tell application "System Events"
    # doesn't work due to mouse not being defined
    set mousePosition to position of the mouse
end tell
