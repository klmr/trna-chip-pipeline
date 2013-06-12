# Call tRNA peaks using annotation
input="$1"
output="$2"
annotation="$project_data_dir/$(read_conf trna-call-peaks annotation)"

while read chr trna type from to rest; do
    line="$chr	$trna	$type	$from	$to	$rest"
    if [ $from -gt $to ]; then
        tmp=$from
        from=$to
        to=$tmp
    fi
    over=$(samtools view "$input.bam" "$chr:$from-$to" | wc -l)
    upstream=$(samtools view "$input.bam" "$chr:$(($from - 100))-$from" | wc -l)
    downstream=$(samtools view "$input.bam" "$chr:$to-$(($to + 100))" | wc -l)
    if [ $over -gt 10 -a $upstream -gt 10 -a $downstream -gt 10 ]; then
        echo "$line	$(( ($over + $upstream + $downstream) / 3))"
    else
        echo "$line	0"
    fi
done < "$annotation" > "$output.dat"
