# 使用较小的基础镜像
FROM ubuntu:22.04

# 设置环境变量，避免交互式安装
ENV DEBIAN_FRONTEND=noninteractive


# Install required packages
RUN apt-get update && \
    apt-get install -y git python3 python3-pip \
    vim supervisor sudo openssh-server iputils-ping net-tools curl ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 创建claw用户并设置密码，同时将其加入sudo组
RUN useradd -m -s /bin/bash claw \
    && echo "claw:123456" | chpasswd \
    && usermod -aG sudo claw

# Change working directory
WORKDIR /app

# Copy runner to main directory
COPY run.sh .

# Give acccess to runner
RUN chmod +x run.sh

# Start the runner
CMD ["bash", "run.sh"]
