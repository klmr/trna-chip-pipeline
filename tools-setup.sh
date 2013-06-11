toolpath="/ebi/research/software/Linux_x86_64/bin"

# Use functions instead of aliases so we can export them.

bwa() {
    "$toolpath/bwa" "$@"
}

samtools() {
    "$toolpath/samtools" "$@"
}

reaper() {
    /homes/nenad/local/bin/reaper "$@"
}

reallocateReads() {
    "$thispath/../scripts/plugins/realloc-reads/reallocateReads" "$@"
}

export -f bwa samtools reaper reallocateReads
