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

if [ "$DEPLOY_WEBSITE" != "true" ]; then
    echo "Skipping website"
    docker compose -p wiigolfq up --build -d backend discord-bot
else
    docker compose -p wiigolfq up --build -d
fi

docker exec backend python manage.py migrate