#!/bin/bash
set -e

echo "$(date) deploying $1"

if [ -z "$1" ]; then
    echo "use $0 <repo-name>"
    exit 1
fi

REPO=$1

pushd "$REPO"
git pull
popd

echo "$(date) building"
docker compose rm -f
docker compose build

OLD_CONTAINER=$(docker ps -aqf name=$REPO)

echo "$(date) scaling up $1"
docker compose up -d --no-deps --scale $REPO=2 --no-recreate $REPO

sleep 30

echo "$(date) scaling down $1"
docker container rm -f $OLD_CONTAINER
docker compose up -d --no-deps --scale $REPO=1 --no-recreate $REPO

echo "$(date) deployed $1"