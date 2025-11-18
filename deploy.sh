#!/bin/bash

# Deploy script for Life in the UK App
# Copies relevant files from master to gh-pages

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
# If gh-pages doesn't exist locally, try to fetch it or create it
if ! git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Creating gh-pages branch..."
    git checkout --orphan gh-pages
    git rm -rf .
    git clean -fdx
else
    git checkout gh-pages
    git pull origin gh-pages || echo "Remote gh-pages might not exist yet, skipping pull."
fi

echo "Updating application files..."

FILES="index.html questions_base.json service-worker.js manifest.json icon_480.png favicon.ico"

for f in $FILES; do
    # Checkout file from master to current directory
    git checkout master -- $f
done

# Stage the changes
git add $FILES

echo "Committing and pushing..."
git commit -m "Deploy update to gh-pages"
git push origin gh-pages

echo "Returning to master..."
git checkout master

echo "Deployment complete! Application available at: https://yiminglin-ai.github.io/life-in-the-uk-2/"
