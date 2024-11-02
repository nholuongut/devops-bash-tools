#!/usr/bin/env osascript
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Nho Luong
#  Date: 2022-12-05 16:30:05 +0000 (Mon, 05 Dec 2022)
#
#  https://github.com/nholuongut/devops-bash-tools
#
#  License: see accompanying Nho Luong LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#


# Returns 'true' or 'false' as to whether screensaver is running
#
# Useful to avoid sending clicks or keystrokes during screensaver, as this makes it hard to login
#
# XXX: Caveat: doesn't work on locked screen when screensaver isn't running so not comprehensive

tell application "System Events"
    get running of screen saver preferences
end tell
