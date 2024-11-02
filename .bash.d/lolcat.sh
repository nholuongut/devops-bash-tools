#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

lolz(){
    exec 1> >(lolcat >&2)
}
