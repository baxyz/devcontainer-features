#!/bin/bash

# Test script for shell-history-per-project feature
# Copyright (c) 2025 baxyz
# Licensed under AGPL-3.0 - see LICENSE file for details

set -e

echo "Testing shell-history-per-project feature..."

# Test 1: Check if history directory exists
HISTORY_DIR="/workspaces/.shell-history"
if [ ! -d "$HISTORY_DIR" ]; then
    echo "❌ FAIL: History directory $HISTORY_DIR does not exist"
    exit 1
fi
echo "✅ PASS: History directory exists"

# Test 2: Check if zsh history file exists
ZSH_HISTORY="$HISTORY_DIR/.zsh_history"
if [ ! -f "$ZSH_HISTORY" ]; then
    echo "❌ FAIL: ZSH history file $ZSH_HISTORY does not exist"
    exit 1
fi
echo "✅ PASS: ZSH history file exists"

# Test 3: Check if symbolic link is created
HOME_ZSH_HISTORY="$HOME/.zsh_history"
if [ ! -L "$HOME_ZSH_HISTORY" ]; then
    echo "❌ FAIL: Symbolic link $HOME_ZSH_HISTORY does not exist"
    exit 1
fi

# Check if symbolic link points to the correct location
LINK_TARGET=$(readlink "$HOME_ZSH_HISTORY")
if [ "$LINK_TARGET" != "$ZSH_HISTORY" ]; then
    echo "❌ FAIL: Symbolic link points to $LINK_TARGET instead of $ZSH_HISTORY"
    exit 1
fi
echo "✅ PASS: Symbolic link is correctly configured"

# Test 4: Check if .zshrc is updated with history configuration
if [ -f "$HOME/.zshrc" ]; then
    if grep -q "HISTFILE=\"$ZSH_HISTORY\"" "$HOME/.zshrc"; then
        echo "✅ PASS: .zshrc contains correct HISTFILE configuration"
    else
        echo "❌ FAIL: .zshrc does not contain correct HISTFILE configuration"
        exit 1
    fi
    
    if grep -q "SHARE_HISTORY" "$HOME/.zshrc"; then
        echo "✅ PASS: .zshrc contains ZSH history options"
    else
        echo "❌ FAIL: .zshrc does not contain ZSH history options"
        exit 1
    fi
else
    echo "⚠️  WARN: .zshrc file not found, skipping configuration check"
fi

# Test 5: Check directory permissions
PERMISSIONS=$(stat -c "%a" "$HISTORY_DIR")
if [ "$PERMISSIONS" = "755" ]; then
    echo "✅ PASS: History directory has correct permissions (755)"
else
    echo "⚠️  WARN: History directory permissions are $PERMISSIONS instead of 755"
fi

# Test 6: Test writing and reading history
echo "echo 'test command for history'" >> "$ZSH_HISTORY"
if grep -q "test command for history" "$ZSH_HISTORY"; then
    echo "✅ PASS: Can write to history file"
else
    echo "❌ FAIL: Cannot write to history file"
    exit 1
fi

echo ""
echo "🎉 All tests passed! shell-history-per-project feature is working correctly."
echo ""
echo "Test summary:"
echo "- History directory created: $HISTORY_DIR"
echo "- ZSH history file: $ZSH_HISTORY"
echo "- Symbolic link: $HOME_ZSH_HISTORY -> $ZSH_HISTORY"
echo "- Configuration updated in: $HOME/.zshrc"
