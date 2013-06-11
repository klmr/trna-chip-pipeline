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
    config_file="$1"
    section="$2"
    value="$3"
    $thispath/parse_config read "$config_file" "$section" "$value"
}

read_config_section() {
    config_file="$1"
    section="$2"
    $thispath/parse_config read "$config_file" "$section"
}

read_conf() {
    read_config_value "$project_config" "$1" "$2"
}
