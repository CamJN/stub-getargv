#!/usr/bin/env bash

if [ $# -gt 1 ] && [[ "$2" =~ s\|prefix=\.\*\|prefix=.* ]]; then
    /bin/sed -e "$2" "-i$4" "$5"
else
    /bin/sed "$@"
fi
