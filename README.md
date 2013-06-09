# Description of the project structure

## `run.sh`

The main entry point running the pipeline.

## `process-single-job.sh`

This script is run exactly once for each library. It runs the whole analysis pipeline on that one library.

**TODO**: This only allows for single, linear dependencies. Consider a peak caller which uses replicates or background libraries. Currently this isn’t feasible using this pipeline.

## `tools/`

Folder of the individual tools. Each tool has two arguments, the input and the output name. These are “proto” file names, meaning that they may have to be adorned with file extensions or other suffixes inside a tool. Each tool should know what it expects and produces.

Additionally, each tool has access to the project environment consisting of environment variables starting with the prefix `project_`, and a set of helper functions.

Tools should be platform agnostic. For instance, `map-reads` calls the tool `bwa` but doesn’t care for its path. It is the  job of the pipeline to make this work.

## `tools-setup.sh`

Contains the configuration of the path environment; for instance, this may define an alias `bwa` which resolves to the current machine’s copy of the BWA binary.
