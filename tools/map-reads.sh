# Map short-read library to reference
input="$1"
output="$2"
reference="$project_data_dir/$(read_conf map-reads reference)"

if [ ! -s "$output.sai" ]; then
    bwa aln -t 4 "$reference" "$input.lane.clean.gz" > "$output.sai" ||
        abort "Abort after failing to create $output.sai"
fi

bwa samse -n 50 "$reference" "$output.sai" "$input.lane.clean.gz" |
    samtools view -Sb -T "$reference.fa" - > "$output.bam"
