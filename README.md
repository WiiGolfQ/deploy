# Deploy instructions

```
git clone git@github.com:wiigolfq/deploy
cd deploy
cp .env.example .env
nano .env  #change environment variables: see below
```

- `DISCORD_BOT_TOKEN`
  - token to a discord bot in your server that has admin privileges
- `QUEUE_CHANNEL_ID`
- `MATCH_CHANNEL_ID`
- `LEADERBOARD_CHANNEL_ID`
  - make channels in your server for each of these things, then copy its id by right clicking with developer mode turned on
  - match channel should be a forum
    
- `DJANGO_SECRET`
  - i just recommend looking up a random string generator and putting a really long one in here
- `API_URL`
  - leave as `http://backend:8000` unless you know what you're doing
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
  - postgres credentials to be used by the db container
- `POSTGRES_HOST`
  - leave as `db` unless you know what you're doing
    
- `DEPLOY_WEBSITE`
  - skips the website if `false`
    
- `USE_CLOUDFLARE_TUNNEL`
  - useful if you're hosting without a dedicated ip
  - more instructions below

- `TUNNEL_TOKEN`
  - the token for your cloudflare tunnel
     
- `DEBUG`
  - leave as `false` in production
 
```
# before running install docker: https://docs.docker.com/engine/install
sudo bash scripts/setup.sh
```

once that script finishes, the website will be on port 80 and the backend will be on port 8000

```
# set up a cron job to rebuild on commit

sudo chmod -R $USER .
sudo apt install cron -y
crontab -u $USER -e

/*

add the following to the cronjobs
* * * * * <DEPLOY FOLDER LOCATION>/scripts/deploy_if_changed.sh

*/
```

# Cloudflare tunnel instructions
1. follow steps 1-6 of `1. Create a tunnel` [here](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel#1-create-a-tunnel)
2. you should see a command it wants you to copy. get the tunnel token from there and set it as `TUNNEL_TOKEN`
3. in the tunnels dashboard, click on the tunnel -> edit -> public hostname
4. add the following public hostnames
  - `your.domain` -> `http://<YOUR MACHINE'S PRIVATE IP>:80`
  - `api.your.domain` -> `http://backend:8000`


