#!/bin/bash

# Deploy script for Life in the UK App
# Deploys from current repo to yiminglin-ai.github.io/life-in-the-uk

TARGET_REPO="https://github.com/yiminglin-ai/yiminglin-ai.github.io.git"
DEPLOY_DIR="deploy_stage"
SUBDIR="life-in-the-uk"

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

echo "Cleaning up previous deployment stage..."
rm -rf $DEPLOY_DIR

echo "Cloning target repository ($TARGET_REPO)..."
git clone --depth 1 --branch gh-pages $TARGET_REPO $DEPLOY_DIR

if [ ! -d "$DEPLOY_DIR" ]; then
    echo "Error: Failed to clone target repository."
    exit 1
fi

echo "Updating application files..."
mkdir -p $DEPLOY_DIR/$SUBDIR

FILES="index.html questions_base.json service-worker.js manifest.json icon_480.png favicon.ico"

for f in $FILES; do
    cp $f $DEPLOY_DIR/$SUBDIR/
done

cd $DEPLOY_DIR

# Configure git for the deploy directory
git config user.name "Deploy Script"
git config user.email "deploy@script.local"

echo "Staging changes..."
git add $SUBDIR

if git diff --staged --quiet; then
    echo "No changes to deploy."
else
    echo "Committing and pushing..."
    git commit -m "Update Life in the UK app from source"
    git push origin gh-pages
fi

cd ..
rm -rf $DEPLOY_DIR

echo "Deployment complete! Application available at: https://yiminglin-ai.github.io/life-in-the-uk/"
