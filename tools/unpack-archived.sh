# Unpack gzipped fasta file, if it exists.
# If it doesn't exist we assume it has already been unpacked.
input="$1"
[ -e "$input" ] && gunzip "$input"
