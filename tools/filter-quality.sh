input="$1"
output="$2"

reaper -i "$input" -basename "$output" \
    -geom no-bc -3pa "" -tabu "" -nnn-check 3/5 -clean-length 16 --bcq-early \
    -format-clean '%I%n%C%n+%n%Q%n'
