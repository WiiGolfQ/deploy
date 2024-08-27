#!/bin/bash
set -e

declare -A repos=(
    ["backend"]="https://github.com/WiiGolfQ/backend/"
    ["discord-bot"]="https://github.com/WiiGolfQ/discord-bot/"
    ["website"]="https://github.com/WiiGolfQ/website/"
)

if [ ! -f .env ]; then
    echo "use `cp .env.example .env` and fill in the environment variables"
fi

for dir in "${!repos[@]}"; do
    if [ ! -d "$dir" ]; then
        git clone "${repos[$dir]}" "$dir"
    else
        pushd "$dir"
        git pull
        popd
    fi
done

docker compose up -d backend discord-bot

docker exec backend python manage.py migrate

if [ "$DEPLOY_WEBSITE" == "true" ]; then
    docker compose up -d website
else
    echo "Skipping website"
fi

if [ "$USE_CLOUDFLARE_TUNNEL" == "true" ]; then
    docker compose up -d tunnel
else
    echo "Skipping tunnel"
fi
