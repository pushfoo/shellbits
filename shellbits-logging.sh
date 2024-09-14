#!/usr/bin/env bash

# A mini-library with functions similar to methods on Python's logging.Logger.
# https://docs.python.org/3/library/logging.html

# In addition to any caveats in the README.md:
# 1. Bash-only for now, sorry!
# 2. No real formatting attempted beyond prefixing (and no flexibility, either)
# 3. No real log level, just whether DEBUG is set and to a non-empty string

# | Function  |  Purpose                                                        |
# |-----------|-----------------------------------------------------------------|
# | stderr    | Print all arguments to stderr                                   |
# | debug     | When DEBUG is set and not empty, same as `stderr "DEBUG: $@"`   |
# | info      | Print all arguments to stdout prefixed with "INFO: "            |
# | warning   | Same as `stderr "WARNING: $@"`                                  |
# | error     | Same as `stderr "ERROR: $@"`                                    |


if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "ERROR: This is a mini-library, not a script. Use 'source logging.sh' or copy the code." 1>&2
fi


stderr() {
    # Print all arguments to stderr.
    #
    # Can be used for continuing multi-line messages when necessary.
    cat <<< "$@" 1>&2
}


debug() {
    # Print all arguments to stderr if DEBUG is set to a non-empty value.

    # No parameter expansion (-z ${DEBUG+x}) because that treats empty strings as true.
    # See https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
    if [[ "$DEBUG" ]]; then
        cat <<< "DEBUG: $@" 1>&2
    fi
}

info() {
    # Print all arguments to stdout prefixed by "INFO: ".
    #
    # For example, `info "Test message."` would print:
    # ```
    # INFO: Test message.
    # ```
    cat <<< "INFO: $@"
}

warning() {
    # Print all arguments to stderr prefixed by "WARNING: ".
    # For example, `warning "Couldn't find config file, using defaults."` would print:
    # ```
    # WARNING: Couldn't find config file, using defaults.
    # ```
    cat <<< "WARNING: $@" 1>&2
}

error() {
    # Print all arguments to stderr prefixed by "ERROR: ".
    # For example, `error "Couldn't connect to server!!"` would print:
    # ```
    # WARNING: Couldn't connect to server!
    # ```
    cat <<< "ERROR: $@" 1>&2
}
