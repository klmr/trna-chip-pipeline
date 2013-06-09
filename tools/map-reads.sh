# Map short-read library to reference
input="$1"
output="$2"
reference="$(read_conf map-reads reference)"
bwa=/ebi/research/software/Linux_x86_64/bin/bwa
samtools=/ebi/research/software/Linux_x86_64/bin/samtools

if [ ! -s "$output.sai" ]; then
    $bwa aln -t 4 "$reference" "$input" > "$output.sai" ||
        abort "Abort after failing to create $output.sai"
fi

$bwa samse -n 50 "$reference" "$output.sai" "$input" |
    $samtools view -Sb -T "$reference.fa" - > "$output.bam"
