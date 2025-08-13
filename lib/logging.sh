#!/usr/bin/env bash

# A mini-library with functions inspired by Python's logging tools.
#
# Python's [logging][] module defines a number of logging
# functions and constants. The `SHELLBITS_LOG_LEVEL` variable
# allows setting a level when running a command. You can set
# it in one of two ways:
#
# * Directly (`SHELLBITS_LOG_LEVEL=50`)
#   - Best for script launches
#   - Example: `SHELLBITS_LOG_LEVE=50 wat tree`
#
# * The `set_log_level` function any of:
#   - n >= 0 as a number literal or `SHELLBITS_LOG_*` value
#   - lower case level names ("info")
#   - upper case level names ("INFO")
#
# This give you control over the following functions:
#
# | Function  |  Action                  | Minimum log level        |                                                           |
# |-----------|--------------------------|--------------------------|
# | stderr    | Print all args to stderr | None                     |
# | critical  | `stderr "CRITICAL: $@"`  | `SHELLBITS_LOG_CRITICAL` |
# | error     | `stderr "ERROR: $@"`     | `SHELLBITS_LOG_ERROR`    |
# | warning   | `stderr "WARNING: $@"`   | `SHELLBITS_LOG_WARNING`  |
# | info      | `stderr "INFO: $@"`      | `SHELLBITS_LOG_INFO`     |
# | debug     | `stderr "DEBUG: $@"`     | `SHELLBITS_LOG_DEBUG`    |
#
# [logging]: https://docs.python.org/3/library/logging.html


if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "${BASH_SOURCE[0]}: WARNING: This is a mini-library, not a script. Use via 'source \"\$SHELLBITS_LIB/logging.sh\" or copy the code." 1>&2
fi

# The default logging levels.
SHELLBITS_LOG_SILENT=0
SHELLBITS_LOG_CRITICAL=10
SHELLBITS_LOG_ERROR=20
SHELLBITS_LOG_WARNING=30
SHELLBITS_LOG_INFO=40
SHELLBITS_LOG_DEBUG=50


_set_level_and_echo() {
    local level="$1"
    SHELLBITS_LOG_LEVEL="$level"
    echo "$level"
}

set_log_level() {
    if [[ "$1" =~ "^[0-9]+$" ]]; then
        _set_log_level_and_echo "$1"
    else
        local upper="$(echo "$1" | awk '{print toupper($0)}')"
        case "$upper" in
            SILENT)
                _set_level_and_echo "$SHELLBITS_LOG_SILENT";;
            CRITICAL)
                _set_level_and_echo "$SHELLBITS_LOG_CRITICAL";;
            ERROR)
                _set_level_and_echo "$SHELLBITS_LOG_ERROR";;
            WARNING)
                _set_level_and_echo "$SHELLBITS_LOG_WARNING";;
            INFO)
                _set_level_and_echo "$SHELLBITS_LOG_INFO";;
            DEBUG)
                _set_level_and_echo "$SHELLBITS_LOG_DEBUG";;
            *)
                echo "ERROR: invalid log level \"$1\"" 1>&2
                echo ""
                ;;
        esac
    fi
}

if [ -z ${SHELLBITS_LOG_LEVEL+x} ]; then
    set_log_level "warning" > /dev/null
fi


stderr() {
    # Print all arguments to stderr.
    #
    # Can be used for continuing multi-line messages when necessary.
    cat <<< "$@" 1>&2
}


critical() {
    # Log `"CRITICAL: "` and all args to stderr if log level is at least `SHELLBITS_LOG_CRITICAL`.
    #
    # For example, `critical "No network connection!"` prints:
    #
    # * nothing if `SHELLBITS_LOG_LEVEL` is too low
    # * `CRITICAL: No network connection!` if at least `SHELLBITS_LOG_CRITICAL`
    if [ "$SHELLBITS_LOG_LEVEL" -ge "$SHELLBITS_LOG_CRITICAL" ]; then
        cat <<< "CRITICAL: $@" 1>&2
    fi
}


error() {
    # Log `"ERROR: "` and all args to stderr if log level is at least `SHELLBITS_LOG_ERROR`.
    #
    # For example, `warning "No config file found!"` prints:
    #
    # * nothing if `SHELLBITS_LOG_LEVEL` is too low
    # * `WARNING: No config file found!` if at least `SHELLBITS_LOG_ERROR`
    if [ "$SHELLBITS_LOG_LEVEL" -ge "$SHELLBITS_LOG_ERROR" ]; then
        cat <<< "ERROR: $@" 1>&2
    fi
}

warning() {
    # Log `"WARNING: "` and all args to stderr if log level is at least `SHELLBITS_LOG_WARNING`.
    #
    # For example, `warning "No config file found!"` prints:
    #
    # * nothing if `SHELLBITS_LOG_LEVEL` is too low
    # * `WARNING: No config file found!` if at least `SHELLBITS_LOG_WARNING`
    if [ "$SHELLBITS_LOG_LEVEL" -ge "$SHELLBITS_LOG_WARNING" ]; then
        cat <<< "WARNING: $@" 1>&2
    fi
}

info() {
    # Log `"INFO: "` and all args to stderr if log level is at least `SHELLBITS_LOG_INFO`.
    #
    # For example, `info "Loaded config from app.cfg"` prints:
    #
    # * nothing if `SHELBITS_LOG_LEVEL` is too low
    # * `"INFO: Loaded config from app.cfg"` if at least `SHELLBITS_LOG_INFO`

    if [ "$SHELLBITS_LOG_LEVEL" -ge "$SHELLBITS_LOG_INFO" ]; then
        cat <<< "INFO: $@" 1>&2
    fi
}

debug() {
    # Log `"INFO: $@"` to stderr if log level is at least `SHELLBITS_LOG_DEBUG`.
    #
    # For example, `debug "Started reading app.cfg"` prints:
    #
    # * nothing if `SHELLBITS_LOG_LEVEL` is too low
    # * `"DEBUG: Started reading app.cfg"` if at least `SHELLBITS_LOG_DEBUG`
    if [ "$SHELLBITS_LOG_LEVEL" -ge "$SHELLBITS_LOG_DEBUG" ]; then
        cat <<< "DEBUG: $@" 1>&2
    fi
}


usage_and_exit() {
    # Call a usage function and `exit` with either a provided code or `0`.
    #
    # Arguments:
    #     exit_code:
    #       An exit code to `exit()` with. Defaults to `0`.
    #     usage_fn:
    #       An executable function to call, defaults to `Usage`.
    #
    local exit_code="$1"
    local usage_fn="$2"
    if [ -z $exit_code ]; then
        exit_code=0
    fi
    if [ -z "$usage_fn" ]; then
        usage_fn="Usage"
    fi

    "$usage_fn"
    exit $exit_code
}

# ifndef-like helper
SHELLBITS_LIB_LOGGING=1
