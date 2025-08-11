#!/usr/bin/env bash

if [ -z "$SHELLBITS_LIB_LOGGING" ]; then
    source "$SHELLBITS_LIB/logging.sh"
fi


get_valid_path_or_cwd() {
    # Echo `""` to fail validation, `$path`, or `$(pwd)` if no  path was given.
    #
    # 1. If `$path` is an empty string, return `$(pwd)`
    # 2. If it does not exist, return a blank string (`""`)
    # 3. Otherwise, return `$path` as-is

    if [ -z "$1" ]; then
        echo "$(pwd)"
    elif [ -e "$1" ]; then
        echo "$1"
    else
        echo ""
    fi
}

get_error_for_path_arg() {
    # Echo `""` for non-blank existing paths or an error suffix.
    #
    # Error suffixes are meant to be used as `"$path $message"`:
    #
    # ```bash
    # fn_name() {
    #     problem="$(get_error_for_path_arg "$1")"
    #     if [ ! -z "$problem" ]; then
    #         error "fn_name $problem"
    #     else
    #         echo "Doing non-error actions."
    #     fi
    # }
    # ```
    local path="$1"
    local problem=""
    if [ -z "$path" ]; then
        problem="requires at least one argument"
    elif [ ! -e "$path" ]; then
        problem="got non-existent path '$path'"
    fi
    echo "$problem"
}

remove_trailing_slash() {
    echo "$1" | sed 's/\/*$//'
}

get_file_in_path() {
    # Echoes an absolute path if `$path` ends with `$name` or has it as a child.
    #
    # Returns `""` when neither exist:
    # 1. `$path/$name` when `$path` is a directory
    # 2. `$path` to a file which ends in `$name`

    local path="$1"
    local name="$2"

    local problem="$(get_error_for_path_arg "$1")"
    if [ -z "$problem" ]; then
        if [ -z "$name" ]; then
            problem="takes a filename, but got name='$name'"
        fi
    fi
    if [ ! -z "$problem" ]; then
        error "get_file_in_path $problem"
    fi
    path="$(realpath "$path")"
    local output=""
    if [ -f "$path" ]; then
        if [[ "$path" == *$name ]]; then
            output="$path"
        else
            error "path to file does not end in '$name': $path"
        fi
    elif [ -d "$path" ]; then
        local slashless="$(remove_trailing_slash "$path")"
        local joined="$slashless/$name"
        if [ -f "$joined" ]; then
            output="$joined"
        fi
    fi

    echo "$output"
}

temp_cd() {
    # Temporarily `cd` into `$dest_dir` if differen to run a command.
    #
    # All arguments after the first are treated as a command to run:
    # ```bash
    # temp_cd "~/somedir" ls -hal
    # ```
    # The example above will:
    # 1. `cd` into `~/somedir` if not already in it
    # 2. Execute `ls -hal`
    # 3. If we changed dirs, `cd` back to where we were
    local dest_dir="$1"
    shift
    local current="$(pwd)"
    if [ "$dest_dir" != "current" ]; then
        local revert="$current"
        cd "$dest_dir"
    fi
    "$@"
    if [ ! -z "$revert" ]; then
        cd "$revert"
    fi
}

