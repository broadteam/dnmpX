FROM daocloud.io/library/nginx:1.19-alpine

MAINTAINER <Jueluo chaoyue@live.com>

ARG CONTAINER_PACKAGE_URL

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 安装telnet工具
RUN apk add busybox-extras
