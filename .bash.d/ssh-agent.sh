#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# ============================================================================ #
#                               S S H   A g e n t
# ============================================================================ #

# keychain id_rsa
# . .keychain/$HOSTNAME-sh

ssh_agent(){
    #if [ $UID != 0 ]; then
        local SSH_ENV_FILE=~/.ssh-agent.env
        if [ -f "${SSH_ENV_FILE:-}" ]; then
            # shellcheck source=~/.agent.env
            # shellcheck disable=SC1090,SC1091
            . "$SSH_ENV_FILE" > /dev/null

            if ! kill -0 "$SSH_AGENT_PID" >/dev/null 2>&1; then
                echo "Stale ssh-agent found. Spawning new agent..."
                killall -9 ssh-agent
                eval "$(ssh-agent | tee "$SSH_ENV_FILE")" #| grep -v "^Agent pid [[:digit:]]\+$"
                # lazy evaluated ssh func now so it's not prompted until used
                #ssh-add
            elif [ "$(ps -p "$SSH_AGENT_PID" -o comm=)" != "ssh-agent" ]; then
                echo "ssh-agent PID does not belong to ssh-agent, spawning new agent..."
                eval "$(ssh-agent | tee "$SSH_ENV_FILE")" #| grep -v "^Agent pid [[:digit:]]\+$"
                # lazy evaluated ssh func now so it's not prompted until used
                #ssh-add
            fi
        else
            echo "Starting ssh-agent..."
            killall -9 ssh-agent
            eval "$(ssh-agent | tee "$SSH_ENV_FILE")"
            # lazy evaluated ssh func now so it's not prompted until used
            #ssh-add
        fi
        #clear
    #fi
}

[ -n "${GOOGLE_CLOUD_SHELL:-}" ] && return

ssh_agent
