#!/usr/bin/env bash

if [ "$(uname)" != Darwin ] && [ $# -gt 1 ] && [[ "$2" =~ s\|prefix=\.\*\|prefix=.* ]]; then
    /usr/bin/sed -e "$2" "-i$4" "$5"
else
    /usr/bin/sed "$@"
fi
