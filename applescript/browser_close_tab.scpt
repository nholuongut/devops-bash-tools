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

set defaultBrowser to do shell script "defaults read \\
    ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure \\
    | awk -F'\"' '/http;/{print window[(NR)-1]}{window[NR]=$2}'"

if defaultBrowser is "" or defaultBrowser contains "safari" then
    set defaultBrowser to "Safari"
else if defaultBrowser contains "chrome" then
    set defaultBrowser to "Google Chrome"
else if defaultBrowser contains "firefox" then
    set defaultBrowser to "Firefox"
else
    set defaultBrowser to "Unknown"
end if

-- doesn't work because tell application is needed at compile time, so best we can do is create a script to launch in a separate process
--tell application defaultBrowser
--    keystroke "w" using command down
--end tell

-- doesn't work either
--set theScript to "tell application \"" & defaultBrowser & "\" to keystroke \"w\" using command down"
--do shell script "echo '" & theScript & "'"
--run script theScript

tell application "System Events"
    set frontmostProcess to first process where it is frontmost
    tell process defaultBrowser
        set frontmost to true
        keystroke "w" using command down
        -- capture the original process and switch it back afterwards instead, just in case we're already in the browser we don't want to Cmd-Tab away
        --keystroke tab using command down
    end tell
    set frontmost of frontmostProcess to true
end tell
