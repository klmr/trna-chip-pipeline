input="$1"
output="$2"

reaper -i "$input" -basename "$output" \
    -geom no-bc -3pa "" -tabu "" -nnn-check 3/5 -clean-length 16 \
    -qqq-check 43/9 -trim-length 30 -format-clean '@%I%n%C%n+%n%Q%n'
