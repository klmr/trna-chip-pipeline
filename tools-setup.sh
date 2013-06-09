toolpath="/ebi/research/software/Linux_x86_64/bin"
java_path="/ebi/research/software/Linux_x86_64/opt/java/jdk1.6/bin/java"

bwa() {
    "$toolpath/bwa" "$@"
}

samtools() {
    "$toolpath/samtools" "$@"
}

reaper() {
    /homes/nenad/local/bin/reaper "$@"
}

export java_path
export -f bwa samtools reaper
