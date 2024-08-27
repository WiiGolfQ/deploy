#!/bin/bash
set -e

LOCKFILE=/tmp/deploy.lock
trap "rm -f $LOCKFILE" EXIT

if [ -f "$LOCKFILE" ]; then
    echo "Deploy already in progress"
    exit 1
fi

declare -A repos=(
    ["backend"]="https://github.com/WiiGolfQ/backend/"
    ["discord-bot"]="https://github.com/WiiGolfQ/discord-bot/"
    ["website"]="https://github.com/WiiGolfQ/website/"
)

# go to the deploy folder
DEPLOY_DIR="$(dirname "$0")/.."
cd "$DEPLOY_DIR"

for dir in "${!repos[@]}"; do

    if [ "$dir" == "website" ] && [ "$DEPLOY_WEBSITE" != "true" ]; then
        continue
    fi

    pushd "$dir"
    git fetch
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    if [ "$LOCAL" != "$REMOTE" ]; then
        echo "Changes detected in $dir. Deploying"
        popd
        scripts/deploy.sh "$dir"
    else
        popd
    fi
done

rm -f "$LOCKFILE"