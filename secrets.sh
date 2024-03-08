secrets=("postgres_password" "discord_bot_token" "django_secret")

for secret in "${secrets[@]}"; do
    echo "${secret}:"
    read input
    if [[ $input == \$* ]]; then
        value=$(eval "${input:1}")
    else
        value=$input
    fi
    if docker secret inspect $secret > /dev/null 2>&1; then
        docker secret rm $secret
    fi
    echo $value | docker secret create $secret -
done