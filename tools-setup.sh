# Use functions instead of aliases so we can export them.

reallocateReads() {
    "$thispath/../scripts/plugins/realloc-reads/reallocateReads" "$@"
}

export -f reallocateReads
