toolpath="/ebi/research/software/Linux_x86_64/bin"

bwa() {
    "$toolpath/bwa" "$@"
}

samtools() {
    "$toolpath/samtools" "$@"
}

export -f bwa samtools
