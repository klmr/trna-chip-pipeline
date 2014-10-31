set -e
set -u

abort() {
    echo >&2 "$@"
    exit 1
}

abspath() {
    readlink -m "$@"
}

realpath() {
    dirname "$(abspath "$@")"
}

md() {
    mkdir -p "$*" && cd "$*"
}

export thispath="$(realpath "$0")"

exists() {
    if [ "$2" != in ]; then
        echo 'Usage: exists {key} in {array}'
        return 1
    fi
    eval "[ \${$3[$1]+isset} ]"
}

read_config_value() {
    $thispath/parse_config read "$@"
}

read_config_section() {
    $thispath/parse_config read "$@"
}

read_conf() {
    read_config_value "$project_config" "$@"
}
