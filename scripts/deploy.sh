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

OLD_CONTAINER=$(docker ps -aqf name=$REPO)

echo "$(date) scaling up $1"
sudo docker compose up -d --no-deps --scale $REPO=2 --no-recreate $REPO

sleep 30

echo "$(date) scaling down $1"
sudo docker container rm -f $OLD_CONTAINER
sudo docker compose up -d --no-deps --scale $REPO=1 --no-recreate $REPO

echo "$(date) deployed $1"