# ---------- 基础镜像 ----------
FROM ubuntu:22.04

LABEL maintainer="you@example.com" \
      description="Squid Cache on Ubuntu 22.04（含推荐配置）"

# ---------- 安装 ----------
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends squid apache2-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ---------- 创建卷与权限 ----------
RUN mkdir -p /var/spool/squid /var/log/squid /etc/squid/conf.d && \
    chown -R proxy:proxy /var/spool/squid /var/log/squid /etc/squid

WORKDIR /root

# ---------- 复制配置 ----------
COPY squid.conf /etc/squid/squid.conf
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# ---------- 端口 ----------
EXPOSE 3128/tcp

# ---------- 默认卷 ----------
VOLUME ["/var/spool/squid", "/var/log/squid"]

# ---------- 入口 ----------
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["squid", "-N", "-d1", "-f", "/etc/squid/squid.conf"]