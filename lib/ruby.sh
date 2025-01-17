#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
#srcdir_bash_tools_python="$(dirname "${BASH_SOURCE[0]}")"

# shellcheck disable=SC1090
#. "$srcdir_bash_tools_python/ci.sh"

# shellcheck disable=SC1090
#. "$srcdir_bash_tools_python/os.sh"

inside_ruby_virtualenv(){
    # $HOME/.rbenv/shims/ruby
    if inside_rvm || inside_rbenv; then
        return 0
    fi
    return 1
}

# https://github.com/rbenv/rbenv#command-reference
inside_rbenv(){
    # $HOME/.rbenv/shims/ruby
    # this could be true and still set to system
    #if command -v ruby | grep -q -e '/\.rbenv/'; then
    #
    #rbenv local - $PWD/.ruby-version
    #rbenv global - ~/.rbenv/version
    # gem env home exposes this in one
    if [ -n "${RBENV_VERSION:-}" ] ||
       gem env home 2>/dev/null | grep -q -e '/\.rbenv/'; then
        # technically should check if $RBENV_ROOT is set and also 'rbenv root' but this would be more expensive and should always be .rbenv anyway
        return 0
    fi
    return 1
}

inside_rvm(){
    if [[ "${GEM_HOME:-}${MY_RUBY_HOME:-}" =~ /\.rvm/ ]] ||
        command -v ruby | grep -q -e '/\.rvm/'; then
        return 0
    fi
    return 1
}
