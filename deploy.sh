#!/bin/bash

# Deploy script for Life in the UK App
# Deploys from current repo to origin's gh-pages branch

# Ensure we are on master
if [[ $(git rev-parse --abbrev-ref HEAD) != "master" ]]; then
  echo "Error: You must be on the master branch to run this script."
  exit 1
fi

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    echo "Error: You have uncommitted changes. Please commit or stash them first."
    exit 1
fi

echo "Switching to gh-pages..."
# Fetch the latest from remote
git fetch origin

# If gh-pages doesn't exist locally, check remote or create orphan
if ! git show-ref --verify --quiet refs/heads/gh-pages; then
    if git show-ref --verify --quiet refs/remotes/origin/gh-pages; then
        echo "Tracking remote gh-pages..."
        git checkout -b gh-pages origin/gh-pages
    else
        echo "Creating orphan gh-pages branch..."
        git checkout --orphan gh-pages
        git rm -rf .
        git clean -fdx
    fi
else
    git checkout gh-pages
    git pull origin gh-pages || echo "Pull failed, continuing..."
fi

echo "Updating application files..."
# We want to deploy to the ROOT of gh-pages, not a subdirectory
# This ensures it works at username.github.io/repo-name/

FILES="index.html questions_base.json service-worker.js manifest.json icon_480.png favicon.ico"

for f in $FILES; do
    # Checkout file from master to current directory
    git checkout master -- $f
done

# Stage the changes
git add $FILES

if git diff --staged --quiet; then
    echo "No changes to deploy."
else
    echo "Committing and pushing..."
    git commit -m "Deploy update to gh-pages"
    git push origin gh-pages
fi

echo "Returning to master..."
git checkout master

echo "Deployment complete! Application available at: https://yiminglin-ai.github.io/life-in-the-uk/"
