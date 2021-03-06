source "$(dirname "$0")/helpers.sh"

experiment=$1
filename="$2"
toolpath="$thispath/tools"

declare -A paths=(
    [qc-report]=fastqc
    [map-reads]=mapped
    [sort-and-index]=indexed
    [reallocate]=reallocated
    [trna-call-peaks]=peaks
)

skip() {
    action="$1"
    if exists $action in paths; then
        md "${paths[$action]}"
    fi
    echo >&2 "[In directory $(pwd)]"
    echo >&2 "[Skipping $action]"
}

perform() {
    action="$1"
    if exists $action in paths; then
        md "${paths[$action]}"
    fi

    input="${2-../$experiment}"
    output="${3-$experiment}"

    echo >&2 "[In directory $(pwd)]"
    echo >&2 "[Perform $action $input $output]"
    set -x
    $SHELL -x "$toolpath/$action.sh" "$input" "$output"
    set +x
}

# No need for this -- downstream tools can work with gzipped files.
#if [[ "$filename" == *.gz ]]; then
#    filename="${filename%.gz}"
#    $SHELL unpack-archived.sh "$filename.gz" "$filename"
#fi

perform filter-quality "$filename"

# Subshell to restore path afterwards
(perform qc-report "$filename")

perform map-reads

perform sort-and-index

perform reallocate

perform sort-and-index

perform trna-call-peaks
