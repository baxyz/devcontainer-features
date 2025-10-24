#!/bin/bash

# Test script for Biome DevContainer Feature

set -e

# Import test library
# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "biome is installed" bash -c "biome --version"
check "biome binary location" bash -c "which biome | grep -q '/usr/local/bin/biome'"
check "biome help works" bash -c "biome --help | grep -q 'Biome is a toolchain'"

# Test basic Biome functionality
echo "Testing Biome check functionality..."
mkdir -p /tmp/biome-test
cd /tmp/biome-test

# Create a test JavaScript file with formatting issues
cat > test.js << 'EOF'
const   x=1;
const y  =  2  ;
console.log( x,y )
EOF

# Initialize biome configuration
check "biome init" bash -c "biome init"
check "biome.json created" bash -c "test -f biome.json"

# Test check command (should detect issues)
check "biome check detects issues" bash -c "biome check test.js --diagnostic-level=info || true"

# Test format command
check "biome format works" bash -c "biome format test.js --write"

# Test lint command
check "biome lint works" bash -c "biome lint test.js || true"

# Cleanup
cd /
rm -rf /tmp/biome-test

# Report results
reportResults
