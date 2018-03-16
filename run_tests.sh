#!/bin/bash

# Tests URL
TESTS_URL="https://"

# Input file path
tests_path=${1:-/tmp/tests}

find ${tests_path} -name "run.sh" -type f -execdir ./run.sh \;

