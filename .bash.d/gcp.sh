#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  shellcheck disable=SC1090,SC1091
#

# ============================================================================ #
#              G C P  -  G o o g l e   C l o u d   P l a t f o r m
# ============================================================================ #

srcdir="${srcdir:-$(dirname "${BASH_SOURCE[0]}")/..}"

# shellcheck disable=SC1090,SC1091
#type add_PATH &>/dev/null || . "$srcdir/.bash.d/paths.sh"

# adds GCloud CLI tools to $PATH
if [ -f ~/google-cloud-sdk/path.bash.inc ]; then
    #source ~/google-cloud-sdk/path.bash.inc
    add_PATH ~/google-cloud-sdk/bin  # appends rather than above which prepends to \$PATH, messing up kubectl version requirement for fluxcd
fi

# Bash completion for GCloud CLI tools
if [ -f ~/google-cloud-sdk/completion.bash.inc ]; then
    source ~/google-cloud-sdk/completion.bash.inc
fi

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# having to retype this way too much
alias gal="gcloud auth login"
# often bugs me to do this
alias gcu="gcloud components update"

alias gce="gcloud compute"
alias gke="gcloud container clusters"
alias gc="gcloud container"
alias gbs="gcloud builds submit --tag"
alias bqq="bq query"
alias gssh="gcloud compute ssh"

# when switching an alias to a function during re-source without un-aliasing, declare function explicitly to avoid errors
function gcloudconfig(){
    # configurations are usually called the same as the project name so export GOOGLE_PROJECT_ID for convenience too
    gcloud config configurations activate "$1" || return 1
    export GOOGLE_PROJECT_ID="$1"
}

gsopen(){
    local gspath="$1"
    gspath="${gspath#gs:\/\/}"
    browser "https://console.cloud.google.com/storage/browser/$gspath"
}

gcropen(){
    local image="$1"
    if ! [[ "$image" =~ gcr\.io/ ]]; then
        echo "'$image' is not a GCR image name (requires gcr.io to know where to open)"
        return 1
    fi
    image="${image%:*}"
    browser "https://$image"
}
