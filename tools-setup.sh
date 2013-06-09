toolpath="/ebi/research/software/Linux_x86_64/bin"

bwa() {
    "$toolpath/bwa" "$@"
}

samtools() {
    "$toolpath/samtools" "$@"
}

reaper() {
    /homes/nenad/local/bin/reaper "$@"
}

export -f bwa samtools reaper
