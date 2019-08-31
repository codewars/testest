#!/usr/bin/env bash

example_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)
repo_root=$(dirname "$example_dir")

cd "$example_dir"
FACTOR_ROOTS="$repo_root:$example_dir" factor -run=kata.tests
