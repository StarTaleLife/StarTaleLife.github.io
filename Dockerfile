FROM node:11

# 使用公共 npm 源（如果私有源不可用，可以取消下面这行的注释）
# RUN echo "registry=https://nexus.tsingjyujing.com/repository/npm/" > /root/.npmrc

# 修复 Debian Stretch 归档问题，将源指向 archive
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list || true

# Set environment - 安装 GitBook
RUN npm install gitbook-cli -g && \
    gitbook install

# 安装 git（可选，如果需要 git 功能）
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean || true

# Build book
WORKDIR /book
COPY . .