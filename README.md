This repository contains instructions for deploying all the components of WiiGolfQ using Docker.

- [backend](https://github.com/WiiGolfQ/backend)
- [discord-bot](https://github.com/WiiGolfQ/discord-bot)
- [website](https://github.com/WiiGolfQ/website)

# Deploy Instructions

```
git clone git@github.com:wiigolfq/deploy
cd deploy
cp .env.example .env
nano .env  #change environment variables: see below
```


- `DISCORD_BOT_TOKEN`
  - Token for a Discord bot in your server that has admin privileges.
- `QUEUE_CHANNEL_ID`
- `MATCH_CHANNEL_ID`
- `LEADERBOARD_CHANNEL_ID`
  - Create channels in your server for each of these, then copy their IDs by right-clicking with developer mode turned on.
  - The match channel should be a forum.
    
- `DJANGO_SECRET`
  - [A secret key for Django. Should be a long, random string.](https://docs.djangoproject.com/en/2.2/ref/settings/#std:setting-SECRET_KEY)
- `API_URL`
  - Leave as `http://backend:8000/v1` unless you know what you're doing.
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
  - Postgres credentials to be used by the `db` container.
- `POSTGRES_HOST`
  - Leave as `db` unless you know what you're doing.
    
- `DEPLOY_WEBSITE`
  - Skips the website if `false`.
    
- `USE_CLOUDFLARE_TUNNEL`
  - Useful if you're hosting without a dedicated IP.
  - More instructions below.

- `TUNNEL_TOKEN`
  - The token for your Cloudflare tunnel.
     
- `DEBUG`
  - Leave as `false` in production.
 
 
```
# before running install docker: https://docs.docker.com/engine/install
sudo bash scripts/setup.sh
```

Once that script finishes, the website will be on port 80 and the backend will be on port 8000.

```
# set up a cron job to rebuild on commit

sudo apt install cron -y
sudo chown -R root .  # this is so wrong... sorry about this i'll fix it later
sudo su
crontab -e

/*

add the following to the cronjobs
* * * * * <DEPLOY FOLDER LOCATION>/scripts/deploy_if_changed.sh

*/
```

# Cloudflare Tunnel Instructions
1. Follow steps 1-6 of `1. Create a tunnel` [here](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel#1-create-a-tunnel).
2. After completing step 6, you should see a command it wants you to copy. Get the tunnel token from there and set it as `TUNNEL_TOKEN`.
3. In the Tunnels dashboard, click on the tunnel -> Edit -> Public Hostname.
4. Add the following public hostnames:
  - `your.domain` -> `http://<YOUR MACHINE'S PRIVATE IP>:80`
  - `api.your.domain` -> `http://backend:8000`


