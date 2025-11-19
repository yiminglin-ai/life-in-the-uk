#!/bin/bash

# Script to remove life-in-the-uk from yiminglin-ai.github.io to fix shadowing issue

TARGET_REPO="https://github.com/yiminglin-ai/yiminglin-ai.github.io.git"
CLEANUP_DIR="cleanup_stage"
SUBDIR="life-in-the-uk"

echo "Cloning target repository ($TARGET_REPO)..."
rm -rf $CLEANUP_DIR
git clone --depth 1 --branch gh-pages $TARGET_REPO $CLEANUP_DIR

if [ ! -d "$CLEANUP_DIR" ]; then
    echo "Error: Failed to clone target repository."
    exit 1
fi

cd $CLEANUP_DIR

if [ -d "$SUBDIR" ]; then
    echo "Found $SUBDIR in yiminglin-ai.github.io. Removing..."
    git rm -rf $SUBDIR
    
    # Configure git for the cleanup directory
    git config user.name "Cleanup Script"
    git config user.email "cleanup@script.local"
    
    git commit -m "Remove life-in-the-uk folder to allow project repo to take precedence"
    git push origin gh-pages
    echo "Removal complete."
else
    echo "$SUBDIR not found in yiminglin-ai.github.io gh-pages branch. Nothing to do."
fi

cd ..
rm -rf $CLEANUP_DIR

