#!/bin/bash
# .agent/skills/git-worktree-isolation/scripts/verify-and-setup.sh
# Helper script for git-worktree-isolation skill

set -e

BRANCH_NAME=$1
ISOLATION_PATH=$2

if [ -z "$BRANCH_NAME" ] || [ -z "$ISOLATION_PATH" ]; then
  echo "Usage: $0 <branch-name> <isolation-path>"
  exit 1
fi

# Detect project root
PROJECT_ROOT=$(git rev-parse --show-toplevel)
DIR_NAME=$(basename "$ISOLATION_PATH")

# Safety Verification: Check if directory is ignored
if ! git check-ignore -q "$ISOLATION_PATH" 2>/dev/null; then
  echo "Safety Error: Isolation directory '$ISOLATION_PATH' is NOT ignored by git."
  echo "Action Required: Add '$ISOLATION_PATH' to .gitignore and commit before proceeding."
  exit 1
fi

# Create Worktree
echo "Creating worktree at $ISOLATION_PATH/$BRANCH_NAME..."
git worktree add "$ISOLATION_PATH/$BRANCH_NAME" -b "$BRANCH_NAME"

# Change directory
cd "$ISOLATION_PATH/$BRANCH_NAME"

# Flutter Setup
if [ -f pubspec.yaml ]; then
  echo "Running flutter pub get..."
  flutter pub get
fi

# Baseline Verification
if [ -f pubspec.yaml ]; then
  echo "Running baseline tests..."
  flutter test
fi

echo "Worktree ready at $(pwd)"
