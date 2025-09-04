# Simple docker image for [claw.cloud](https://run.claw.cloud)

<br>

### 📦 Run:
```sh
docker pull ghcr.io/wangzhewudiya/claw:squids


docker run -d --name squid \
  -p 3128:3128 \
  -v "$(pwd)/data/cache:/var/spool/squid" \
  -v "$(pwd)/data/logs:/var/log/squid" \
  --restart unless-stopped \
  ghcr.io/wangzhewudiya/claw:squid
```
