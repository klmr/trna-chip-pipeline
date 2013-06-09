java_path="/ebi/research/software/Linux_x86_64/opt/java/jdk1.6/bin/java"
input="$1"
output="$2"

mkdir -p "$output"
fastqc -o "$output" -j "$java_path" "$input"
