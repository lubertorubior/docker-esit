#!/bin/bash

# Tests URL
REPO_URL="https://github.com/lubertorubior/docker-esit"
TEST_DIR="test"

# Input file path
tests_path="${1:-/tmp/docker-tests}"

echo -e "${Cyan}Testing docker-esit...${COff}"
echo -e "${Cyan}---------------------------------${COff}"

# Download tests from repo
echo -e "${Cyan}Downloading tests from repository${COff}"
mkdir -p "${tests_path}"
cd "${tests_path}"
git init
git remote add origin -f "${REPO_URL}"
git config core.sparsecheckout true
echo "${TEST_DIR}" > .git/info/sparse-checkout
git pull --depth=1 origin master
cd - &>/dev/null
echo -e "${Cyan}Download complete${COff}"

# Run tests
find "${tests_path}" -name "run.sh" -type f -execdir ./run.sh \;

# Clean up directories
rm -rf "${tests_path}"
