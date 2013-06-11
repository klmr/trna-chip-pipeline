#!/usr/bin/env bash

source "$(dirname "$0")/helpers.sh"

process () {
    bsub -M 8000 -R'rusage[mem=8000]' "$SHELL $thispath/process-single-job.sh $1 \"$2\""
}

output=results
logs=logs
project_config="$1"
# Make sure we have an absolute path since we are going to switch the working
# directory while running the pipeline.
project_base="$(realpath "$project_config")"
project_config="$project_base/$(basename "$project_config")"

project_name=$(read_conf project name)
project_data_dir="$project_base/$(read_conf project data_dir)"

# Set up environment.
export project_config project_name project_base project_data_dir
export -f abort abspath realpath md exists read_config_value read_config_section read_conf
source "$thispath/tools-setup.sh"

eval "declare -A libraries=($(read_config_section "$project_config" data))"

md "$project_base/$output"

for lib in "${!libraries[@]}"; do
    filename="${libraries[$lib]}"
    # If path is relative, assume it's relative to project's data directory.
    if [[ "$filename" != /* ]] && [[ "$filename" != ~* ]]; then
        filename="$project_data_dir/$filename"
    fi
    process $lib "$filename"
done
