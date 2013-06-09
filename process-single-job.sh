source "$(dirname "$0")/helpers.sh"

experiment=$1
filename="$2"
toolpath="$thispath/tools"

declare -A paths=(
    [qc-report]=fastqc
    [map-reads]=mapped
    [sort-and-index]=indexed
    [reallocate]=reallocated
    [trna-peak-calling]=peaks
)

SHELL="echo $SHELL"

perform() {
    action="$1"
    input="${2-../$experiment}"
    output="${3-$experiment}"
    if exists $action in paths; then
        md "${paths[$action]}"
    fi

    # FIXME Also provide project environment (base path, data path) because some
    # tools need it (e.g. BWA for the reference genome location), as environment
    # variables.
    $SHELL "$toolpath/$action.sh" "$input" "$output"
}

if [[ "$filename" == *.gz ]]; then
    filename="${filename%.gz}"
    $SHELL unpack-archived.sh "$filename.gz" "$filename"
fi

perform filter-quality "$filename"

# Subshell to restore path afterwards
(perform qc-report)

perform map-reads

perform sort-and-index

perform reallocate

perform sort-and-index

perform trna-peak-calling
