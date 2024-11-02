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
#

# Returns the default browser in Apple application name usable format, eg. "Google Chrome"

set defaultBrowser to do shell script "defaults read \\
    ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure \\
    | awk -F'\"' '/http;/{print window[(NR)-1]}{window[NR]=$2}'"

if defaultBrowser is "" or defaultBrowser contains "safari" then
    set defaultBrowser to "Safari"
else if defaultBrowser contains "chrome" then
    set defaultBrowser to "Google Crhome"
else if defaultBrowser contains "firefox" then
    set defaultBrowser to "Firefox"
else
    set defaultBrowser to "Unknown"
end if
