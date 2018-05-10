#!/bin/bash

if [ -z "$3" ] ; then
    echo "usage: $0 stdout_file stderr_file program [program_args]"
    exit 1
fi

st_out=$1
shift
st_err=$1
shift
program=$1
shift

qsub -cwd -o "${st_out}" -e "${st_err}" ${program} "${@}"

