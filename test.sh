##!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
    echo "Test all lexers with the existing samples."
    echo "Usage: $0 path/to/rougify"
    exit 0
fi

# Test lexers with all samples
for sample in ./samples/*; do
    if ! ls ./lexers/*.rb | sed 's/^/-r /g' | xargs ${@:1} $sample > /dev/null; then
        echo "Error while parsing $sample" 1>&2
        exit 1;
    fi
done
echo "All tests passed successfully"
