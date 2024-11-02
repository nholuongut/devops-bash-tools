#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# This is designed to mimick the standard GCP CloudShell behaviour
# of re-customizing a new CloudShell

if ! [ "${AWS_EXECUTION_ENV:-}" = "CloudShell" ]; then
    return
fi

customize_script=~/.aws_customize_environment

lockdir=/tmp/aws_customize_environment.lock

completion_semaphore="/.aws_customize_environment_completed"

if ! [ -f "$customize_script" ]; then
    return
fi

if [ -f "$completion_semaphore" ]; then
    return
fi

# XXX: if the lockdir is more than 2 hours old and the completion semaphore wasn't found, remove the lockdir to try again
if [ -d "$lockdir" ] && ! [ -f "$completion_semaphore" ]; then
    lockdir_epoch="$(stat -c %Y "$lockdir")"
    current_epoch="$(date +%s)"
    if [ $((current_epoch - lockdir_epoch)) -gt 7200 ]; then
        rmdir "$lockdir"
    fi
fi

# used as a mutex lock
mkdir "$lockdir" 2>/dev/null || return

sudo bash <<EOF
    {

        date
        echo

        bash "$customize_script" &&

        rmdir "$lockdir" &&

        sudo UMASK=0044 touch "$completion_semaphore" &

    } > /var/log/customize_environment 2>&1
EOF
