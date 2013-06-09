#!/usr/bin/env bash

source "$(dirname "$0")/helpers.sh"

process () {
    bsub -I "$SHELL $thispath/process-single-job.sh $1 \"$2\""
}

output=results
logs=logs
config="$1"
project_base="$(realpath "$config")"
config="$project_base/$(basename "$config")"

# ...

md "$project_base/$output"

library=(do1234)

# Set up environment.

project_name=$(read_conf name)
project_data_dir=$(read_conf data_dir)

export project_name project_base project_data_dir

for experiment in "${library[@]}"; do
    filename=...
    filename=foo.fa
    process $experiment "$filename"
done
