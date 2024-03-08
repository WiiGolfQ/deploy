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

docker compose up --build