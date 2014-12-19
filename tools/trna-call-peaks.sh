# Call tRNA peaks using annotation
input="$1"
output="$2"
annotation="$project_data_dir/$(read_conf trna-call-peaks annotation)"

# Read individual parts and reconstruct line in order to get rid of excess
# whitespace.

# OLD FORMAT:
# chr1	 .trna1000	AspGTC 	172995560	172995489	  Asp 	GTC	 72 bp  Sc: 72.92
# NEW FORMAT (tRNAScan-SE native):
# 1	284	78297795	78297866	Pro	AGG	0	0	48.57	Bo
while read chr trna from to rest; do
    line="$chr	$trna	$from	$to	$rest"
    if [ $from -gt $to ]; then
        tmp=$from
        from=$to
        to=$tmp
    fi
    over=$(samtools view "$input.bam" "$chr:$from-$to" | wc -l)
    upstream=$(samtools view "$input.bam" "$chr:$(($from - 100))-$from" | wc -l)
    downstream=$(samtools view "$input.bam" "$chr:$to-$(($to + 100))" | wc -l)

    # FIXME We do not use a cutoff at the moment since a per-gene cutoff
    # (rather than one across all conditions) could result in calling gene A
    # unexpressed in condition 1 but expressed in condition 2 despite there
    # being only an insignificant difference between the two.
    # At the very least we need to ensure that a gene is expressed in NO
    # condition before calling it unexpressed anywhere.
    echo "$line	$(( ($over + $upstream + $downstream) / 3))"
    #if [ $over -gt 10 -a $upstream -gt 10 -a $downstream -gt 10 ]; then
    #    echo "$line	$(( ($over + $upstream + $downstream) / 3))"
    #else
    #    echo "$line	0"
    #fi
    which_over=0
    if [ $over -gt 10 ]; then
        which_over=1
    fi
    if [ $upstream -gt 10 ]; then
        let which_over+=2
    fi
    if [ $downstream -gt 10 ]; then
        let which_over+=4
    fi

    if [ $which_over -eq 7 ]; then
        echo >&2 "$chr$trna expressed"
    elif [ $which_over -eq 0 ]; then
        echo >&2 "$chr$trna unexpressed"
    else
        echo >&2 "$chr$trna partially expressed: $(printf '%03d' $(bc <<< "obase=2; $which_over"))"
    fi
done < "$annotation" > "$output.dat"
