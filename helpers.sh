set -e
set -u

realpath() {
    dirname "$(readlink -m "$*")"
}

md() {
    echo $(pwd) '->' $*
    mkdir -p "$*" && cd "$*"
}

thispath="$(realpath "$0")"

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

read_conf() {
    read_config_value "$config" "$1" "$2"
}
