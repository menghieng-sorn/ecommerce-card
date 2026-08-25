# Production Runbook — ecommerce-card

Laravel 11 app deployed as a single Docker container (Nginx + PHP-FPM via supervisord), built and deployed via Jenkins.

---

## Architecture

```
┌─────────────────┐     build     ┌────────────────────┐
│  GitHub (dev)   │ ─────────────▶│  Jenkins           │
└─────────────────┘               │  • tests           │
                                  │  • docker build    │
                                  │  • docker push     │
                                  └─────────┬──────────┘
                                            │ ssh
                                            ▼
┌─────────────────┐   port 80    ┌──────────────────────┐
│  Docker         │ ◀─────────── │  Ubuntu server       │
│  ecommerce-card │              │  192.168.137.207     │
│  (Nginx+FPM)    │              │                      │
└─────────────────┘              │  + Caddy/Nginx       │
                                  │    (TLS termination) │
                                  └──────────────────────┘
                                            │
                                            ▼
                                  ┌──────────────────────┐
                                  │  MySQL/MariaDB       │
                                  │  (separate server)   │
                                  └──────────────────────┘
```

---

## First-time setup (Ubuntu host, 192.168.137.207)

### 1. Install Docker
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker ubuntu
# log out + back in
```

### 2. Create app directories
```bash
sudo mkdir -p /home/ubuntu/ecommerce-card
sudo chown -R ubuntu:ubuntu /home/ubuntu
```

### 3. Place production `.env` (choose one method)

**Method A — server-side file (simpler):**
```bash
sudo nano /home/ubuntu/.env.ecommerce-card
sudo chmod 600 /home/ubuntu/.env.ecommerce-card
```
Fill in all required keys (APP_URL, DB_*, MAIL_*, etc.). Save.

**Method B — Jenkins credential (recommended for shared ops):**
1. Jenkins → Manage Jenkins → Credentials → (global) → Add Credentials
2. Kind: **Secret file**
3. File: upload your production `.env`
4. ID: **`laravel-env-production`**
5. Save. The Jenkinsfile reads this credential by ID.

### 4. Set up reverse proxy (pick one)

**Caddy (easiest — auto TLS):**
```bash
cd /tmp
curl -O https://raw.githubusercontent.com/yourorg/ecommerce-card/main/deploy/caddy/setup-caddy.sh
# edit Caddyfile to replace yourdomain.com, then:
sudo cp Caddyfile /etc/caddy/Caddyfile
sudo systemctl reload caddy
```

**Nginx + Certbot:**
```bash
sudo apt install -y nginx certbot python3-certbot-nginx
# copy deploy/nginx-tls/nginx-tls.conf, edit domain, then:
sudo ln -s /etc/nginx/sites-available/ecommerce-card /etc/nginx/sites-enabled/
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
sudo systemctl reload nginx
```

### 5. Open firewall ports
```bash
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

---

## Jenkins setup

### Required credentials
| ID | Kind | Purpose |
|---|---|---|
| `docker-hub` | Username + password | Push images to Docker Hub |
| `slave2` | SSH private key | SSH to Ubuntu host |
| `laravel-env-production` | Secret file | Production `.env` |

### First build parameters
- `Env = Test`
- `executeTests = true`
- `APPVERSION = 1.3` (or current)
- `pushImage = true`
- `pruneOldImages = true`
- `useSecureEnv = true` (recommended)

Click **Build**. Expected timeline: ~3–8 min.

---

## Deploy procedure

1. Push code to `dev` branch on GitHub.
2. Open Jenkins job → **Build with Parameters**.
3. Set `APPVERSION` and click **Build**.
4. Stages run: `Laravel Test` → `Containerising` → `Deploy` → `Healthcheck`.
5. Healthcheck polls `http://192.168.137.207/healthcheck` for up to 60s.

### What gets deployed
- Tagged image: `menghieng002/ecommerce-card:${BUILD_NUMBER}` (latest)
- Versioned tag: `menghieng002/ecommerce-card:${APPVERSION}`
- Container: `ecommerce-card` on port 80, restart=unless-stopped
- Old images: pruned, last `${KEEP_IMAGES}` (3) kept

---

## Rollback

```bash
ssh ubuntu@192.168.137.207

# list images
sudo docker images menghieng002/ecommerce-card

# roll back to a previous build
sudo docker stop ecommerce-card
sudo docker rm ecommerce-card
sudo docker run -d \
  --name ecommerce-card \
  --restart unless-stopped \
  -p 80:80 \
  menghieng002/ecommerce-card:<OLD_BUILD_NUMBER>

# verify
curl http://192.168.137.207/healthcheck
```

Or re-run the Jenkins job with an older `BUILD_NUMBER` from Docker Hub.

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Build fails: `failed to solve: failed to compute cache key: "/.env": not found` | Missing `.env` | Re-create `/home/ubuntu/.env.ecommerce-card` or upload Jenkins credential |
| Container keeps restarting | Bad `.env` (DB unreachable, etc.) | `sudo docker logs ecommerce-card` |
| Healthcheck FAIL loop | Nginx didn't start or PHP-FPM crashed | `sudo docker logs ecommerce-card 2>&1 | tail -100` |
| `unauthorized: access denied` (push) | Wrong Docker Hub creds | Update `docker-hub` credential in Jenkins |
| App shows 500 after deploy | Old opcache / stale config | `sudo docker exec ecommerce-card php artisan config:clear` |
| Out of disk | Old images not pruned | `sudo docker system prune -af` |
| Permission errors in `storage/` | Wrong ownership | `sudo docker exec ecommerce-card chown -R www-data:www-data /var/www/html/storage` |

### Tail logs
```bash
ssh ubuntu@192.168.137.207
sudo docker logs -f ecommerce-card
```

### Shell into running container
```bash
sudo docker exec -it ecommerce-card sh
```

---

## Secrets management

- `.env` is **never** in the image, **never** in git, **never** on a long-lived path on the server.
- Method A: lives at `/home/ubuntu/.env.ecommerce-card` (chmod 600), copied in, used by BuildKit `--secret`, shredded after build.
- Method B: stored in Jenkins credentials (encrypted at rest by Jenkins).
- To rotate: update the source → run a new Jenkins build.

---

## Backups

### Database (recommended cron on DB host)
```cron
0 3 * * * /usr/bin/mysqldump -u backup -p'SECRET' ecommerce_card | gzip > /backups/db-$(date +\%F).sql.gz
```

### Application storage
Laravel `storage/` is inside the container. For persistent uploads:
- Mount a host volume: `-v /home/ubuntu/storage:/var/www/html/storage`
- Or back up the container: `sudo docker commit ecommerce-card ecommerce-card:backup-$(date +%F)`

---

## Monitoring (lightweight)

- **Uptime:** point external monitor (UptimeRobot, etc.) at `https://yourdomain.com/healthcheck`
- **Container health:** built-in Docker `HEALTHCHECK` every 30s
- **Logs:** `sudo docker logs -f ecommerce-card` or pipe to a log shipper

---

## Updating the app

```bash
# On dev branch
git add . && git commit -m "feat: ..."
git push origin dev

# Then run Jenkins job
```

That's it. The pipeline pulls `dev`, rebuilds, and redeploys.

---

## Files in this repo

| File | Purpose |
|---|---|
| `Dockerfile` | Multi-stage build, single container (Nginx + PHP-FPM) |
| `.dockerignore` | Excludes dev files from build context |
| `docker/nginx.conf` | Container-level Nginx |
| `docker/supervisord.conf` | Runs Nginx + PHP-FPM |
| `Jenkinsfile` | CI/CD pipeline |
| `server-script.sh` | Build script run on Ubuntu host |
| `deploy/caddy/Caddyfile` | Host-level TLS proxy (Caddy) |
| `deploy/caddy/setup-caddy.sh` | Caddy installer |
| `deploy/nginx-tls/nginx-tls.conf` | Host-level TLS proxy (Nginx) |
| `deploy/nginx-tls/setup-nginx-tls.sh` | Nginx + Certbot installer |
| `PRODUCTION.md` | This file |
