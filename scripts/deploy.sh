#!/bin/bash
set -e

echo "$(date) deploying $1"

if [ -z "$1" ]; then
    echo "use $0 <repo-name>"
    exit 1
fi

# go to the deploy folder
DEPLOY_DIR="$(dirname "$0")/.."
cd "$DEPLOY_DIR"

REPO=$1

pushd "$REPO"
git pull
popd

echo "$(date) building"
sudo docker compose rm -f
sudo docker compose build

# TODO: 0 downtime

echo "$(date) stopping old container"
sudo docker compose down $REPO

echo "$(date) starting new container"
sudo docker compose up $REPO -d

echo "$(date) deployed $1"