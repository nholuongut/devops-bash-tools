#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
#srcdir="$(dirname "${BASH_SOURCE[0]}")"

# XXX: prevents race conditions from changes in global context
kube_config_isolate(){
    local tmp="/tmp/.kube"
    local default_kubeconfig="${HOME:-$(cd ~ && pwd)}/.kube/config"
    local original_kubeconfig="${KUBECONFIG:-$default_kubeconfig}"

    mkdir -pv "$tmp"

    kubeconfig="$tmp/config.${EUID:-$UID}.$$"

    if [ -f "$original_kubeconfig" ]; then
        cp -f -- "$original_kubeconfig" "$kubeconfig"
    elif [ -f "$default_kubeconfig" ]; then
        cp -f -- "$default_kubeconfig" "$kubeconfig"
    elif [ -f "$PWD/.kube/config" ]; then
        cp -f -- "$PWD/.kube/config" "$kubeconfig"
    fi

    export KUBECONFIG="$kubeconfig"
}

# run 'kubectl config use-context' only if not already on the desired context, in order to minimize noise
kube_context(){
    local context="$1"
    local namespace="${2:-}"
    local current_context
    current_context="$(kube_current_context)"
    if [ "$context" != "$current_context" ]; then
        kubectl config use-context "$context" >&2
    fi
    kube_namespace "$namespace"
}

kube_current_context(){
    kubectl config current-context
}

kube_current_namespace(){
    kubectl config get-contexts |
    awk "/$(kube_current_context)/ {print \$NF}"
}

kube_namespace(){
    local namespace="$1"
    local current_namespace
    current_namespace="$(kube_current_namespace)"
    if [ "$namespace" != "$current_namespace" ]; then
        local current_context
        current_context="$(kube_current_context)"
        kubectl config set-context "$current_context" --namespace "$namespace" >&2
    fi
}

run_static_pod(){
    local name="$1"
    local image="$2"
    shift || :
    shift || :
    local pod_json
    pod_json="$(kubectl get pod "$name" "$@" -o json 2>/dev/null || :)"

    local cmd=(/bin/sh -c 'if type bash >/dev/null 2>&1; then exec bash; else exec sh; fi')

    launch_static_pod(){
        exec kubectl run -ti --rm --restart=Never "$name" --image="$image" "$@" -- "${cmd[@]}"
    }

    if [ -n "$pod_json" ]; then
        if jq -e '.status.phase == "Running"' <<< "$pod_json" >/dev/null; then
            kubectl exec -ti "$name" "$@" -- "${cmd[@]}"
        elif jq -e '.status.phase == "Succeeded" or .status.phase == "Failed"' <<< "$pod_json" >/dev/null; then
            kubectl delete pod "$name" "$@"
            sleep 3
            launch_static_pod "$@"
        # This is what shows as ContainerCreating in kubectl get pods
        elif jq -e '.status.phase == "Pending"' <<< "$pod_json" >/dev/null; then
            echo "Pod pending..."
            sleep 3
            run_static_pod "$name" "$image" "$@"
        else
            echo "ERROR: Pod already exists. Check its state and remove it?"
            kubectl get pod "$name" "$@"
            return 1
        fi
    else
        launch_static_pod "$@"
    fi
}
