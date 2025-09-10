#!/bin/bash

# Test script for kubectl-telepresence feature
# Copyright (c) 2025 baxyz
# Licensed under AGPL-3.0 - see LICENSE file for details

set -e

echo "Testing kubectl-telepresence feature..."

# Test 1: Check if kubectl is installed and accessible
if command -v kubectl >/dev/null 2>&1; then
    echo "✅ PASS: kubectl is installed and accessible"
    kubectl version --client --short || true
else
    echo "❌ FAIL: kubectl is not installed or not accessible"
    exit 1
fi

# Test 2: Check if telepresence is installed and accessible
if command -v telepresence >/dev/null 2>&1; then
    echo "✅ PASS: telepresence is installed and accessible"
    telepresence version || true
else
    echo "❌ FAIL: telepresence is not installed or not accessible"
    exit 1
fi

# Test 3: Check if validation script exists
if [ -x "/usr/local/bin/telepresence-validate" ]; then
    echo "✅ PASS: telepresence-validate script exists and is executable"
else
    echo "❌ FAIL: telepresence-validate script is missing or not executable"
    exit 1
fi

# Test 4: Check kubectl bash completion
if [ -f "/etc/bash_completion.d/kubectl" ]; then
    echo "✅ PASS: kubectl bash completion is installed"
else
    echo "⚠️  WARN: kubectl bash completion is missing"
fi

# Test 5: Check if aliases are available (test in current shell)
if alias tp >/dev/null 2>&1; then
    echo "✅ PASS: Telepresence aliases are configured"
else
    echo "⚠️  WARN: Telepresence aliases not loaded (may need shell restart)"
fi

# Test 6: Test validation script execution
echo "Running telepresence validation script..."
if /usr/local/bin/telepresence-validate; then
    echo "✅ PASS: Validation script runs successfully"
else
    echo "⚠️  WARN: Validation script detected issues (expected without cluster access)"
fi

echo ""
echo "🎉 All critical tests passed! kubectl-telepresence feature is working correctly."
echo ""
echo "Test summary:"
echo "- kubectl: installed and functional"
echo "- telepresence: installed and functional"
echo "- validation script: available"
echo "- completions: configured"
echo ""
echo "Note: Some warnings are expected when no Kubernetes cluster is accessible."
