# Sort and index the map
input="$1"
output="$2"

samtools sort "$input.bam" "$output.bam" &&
    samtools index "$output.bam"
