set -e

declare -A repos=(
    ["backend"]="https://github.com/WiiGolfQ/backend/"
    ["discord-bot"]="https://github.com/WiiGolfQ/discord-bot/"
    ["website"]="https://github.com/WiiGolfQ/website/"
)

for dir in "${!repos[@]}"; do
    if [ ! -d "$dir" ]; then
        git clone "${repos[$dir]}" "$dir"
    else
        pushd "$dir"
        git pull
        popd
    fi
done

source .env

docker compose -p wiigolfq up -d backend discord-bot

if [ "$DEPLOY_WEBSITE" != "true" ]; then
    docker compose -p wiigolfq up -d website
else
    echo "Skipping website"
fi

if [ "$USE_CLOUDFLARE_TUNNEL" != "true" ]; then
    docker compose -p wiigolfq up -d tunnel
else
    echo "Skipping tunnel"
fi

docker exec backend python manage.py migrate