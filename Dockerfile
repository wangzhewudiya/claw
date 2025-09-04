# 第一阶段：构建阶段 (Builder Stage)
# 使用最新稳定版的Alpine作为构建环境的基础镜像
FROM alpine:3.22 AS builder

# 安装构建所需的工具，例如wget, jq以及可能需要的编译工具（如果需要编译的话）
RUN apk add --no-cache wget jq

# 这里以获取最新FRP版本并下载为例（您可以根据实际需求替换此步骤）
RUN LATEST_FRP_VERSION=$(wget -qO- https://api.github.com/repos/fatedier/frp/releases/latest | jq -r '.tag_name | ltrimstr("v")') \
    && wget -O frp.tar.gz "https://github.com/fatedier/frp/releases/download/v${LATEST_FRP_VERSION}/frp_${LATEST_FRP_VERSION}_linux_amd64.tar.gz" \
    && tar -xzf frp.tar.gz \
    && mv frp_${LATEST_FRP_VERSION}_linux_amd64/frps /tmp/frps \
    && rm -rf frp_${LATEST_FRP_VERSION}_linux_amd64 frp.tar.gz

# 第二阶段：运行阶段 (Runtime Stage)
# 再次使用Alpine基础镜像来创建最终的轻量级运行环境
FROM alpine:3.22

# 从构建阶段（builder）只复制必要的可执行文件到当前镜像
COPY --from=builder /tmp/frps /usr/local/bin/frps

# 创建存放配置文件的目录
RUN mkdir -p /etc/frp

WORKDIR /etc/frp

COPY frps.toml /etc/frp/frps.toml

# 指定容器启动时默认运行的命令
ENTRYPOINT ["/usr/local/bin/frps", "-c", "/etc/frp/frps.toml"]