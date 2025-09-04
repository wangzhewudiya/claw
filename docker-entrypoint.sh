#!/bin/bash
set -e

# 如果缓存目录为空，则初始化
if [[ ! -d /var/spool/squid/00 ]]; then
    echo "Initializing cache..."
fi

# 如果第一个参数是 squid，则替换为完整路径
if [ "$1" = "squid" ]; then
    set -- "$(which squid)" "${@:2}"
fi

exec "$@"