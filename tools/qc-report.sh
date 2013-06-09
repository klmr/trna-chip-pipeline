input="$1"
output="$2"

mkdir -p "$output"
fastqc -o "$output" -j "$java_path" "$input"
