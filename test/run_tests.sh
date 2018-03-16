#!/bin/bash

# Tests URL
TESTS_URL="https://github.com/lubertorubior/docker-esit/raw/master/test/test.tar.gz"

# Input file path
tests_path=${1:-/tmp/tests}

# Download and unzip tests
mkdir -p ${tests_path}
cd ${tests_path}; curl -LJO ${TESTS_URL}; tar -xvzf test.tar.gz; cd -

# Run tests
find ${tests_path} -name "run.sh" -type f -execdir ./run.sh \;

# Clean up directories
rm -rf ${tests_path}

