FROM redis:6.2.4-alpine

MAINTAINER <Jueluo chaoyue@live.com>

ARG CONTAINER_PACKAGE_URL

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 安装vim、telnet等开发工具
RUN apk add --no-cache vim busybox-extras \

# 清除缓存
&& rm -rf /var/cache/apk*

#COPY redis.conf /usr/local/etc/redis/redis.conf

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]

# 对外暴露6379端口
EXPOSE 6379
