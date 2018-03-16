#!/bin/bash

# Tests URL
TESTS_URL="https://github.com/lubertorubior/docker-esit/raw/master/test/test.tar.gz"

# Input file path
tests_path=${1:-/tmp/tests}

# Download and unzip tests
cd ${tests_path}; curl -O -J ${TESTS_URL}; unzip test.zip; cd -

# Run tests
find ${tests_path} -name "run.sh" -type f -execdir { chmod +x run.sh; ./run.sh } \;

