#!/usr/bin/env sh

usage() {
cat << END
Usage: install.sh [FILE]

Add a PATH line for shellbits to .bashrc or another FILE.

END
}


if [ "$#" -le 1 ]; then
    TARGET_FILE="/home/$USER/.bashrc"
    echo "defaulting to ${TARGET_FILE}"
else
    case "$2" in
        --help)
            usage
            ;;
        --*)
            echo "ERROR: invalid flag '--$1'. Try --help" 1>&2
            exit 1
            ;;
        *)
            TARGET_FILE="$2"
            echo "Got target file \"$2\""
            ;;
    esac
fi

if [ ! -f "$TARGET_FILE" ]; then
    ERROR="is not a valid file."
    if [ ! -e "$TARGET_FILE" ]; then
        ERROR="does not exist."
    elif [[ -d "$TARGET_FILE" ]]; then
        ERROR="is a directory."
    fi
    echo "ERROR: '$TARGET_FILE' $ERROR" 1>&2
    exit 1
fi

SHELLBITS_CONF="shellbits config"
THIS_FILE="$(readlink -f "$0")"
SHELLBITS_ROOT="$(dirname $THIS_FILE)"
SHELLBITS_LIB="$SHELLBITS_ROOT/lib"
SHELLBITS_BIN="$SHELLBITS_ROOT/bin"

echo "Got values:"
echo "SHELLBITS_LIB=\"$SHELLBITS_LIB\""
echo "SHELLBITS_BIN=\"$SHELLBITS_BIN\""

result="$(grep "$SHELLBITS_CONF" "$TARGET_FILE")"
if [ ! -z "$result" ]; then
    echo "ERROR: '$TARGET_FILE' indicates shellbits may already be installed:" 1>&2
    echo "$result" 1>&2
    exit 1
fi


cat << EOF >> "$TARGET_FILE"

# Shellbits install config
# (start shellbits config)
export SHELLBITS_LIB="$SHELLBITS_LIB"  # Allows includes, i.e: source "$SHELLBITS_BIN/logging.sh"
export SHELLBITS_BIN="$SHELLBITS_BIN"  # Where shellbits utility scripts are kept.
export PATH=\$PATH:\$SHELLBITS_BIN
# (end shellbits config)

EOF
