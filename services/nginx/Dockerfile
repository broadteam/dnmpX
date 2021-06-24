FROM daocloud.io/library/nginx:1.19-alpine

MAINTAINER <Jueluo chaoyue@live.com>

ARG CONTAINER_PACKAGE_URL

# 直接将站点的nginx配置复制到容器的nginx配置目录
#COPY ./*.conf /etc/nginx/conf.d/

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 安装telnet工具
RUN apk add vim busybox-extras \

# 清除缓存
&& rm -rf /var/cache/apk*

# 对外暴露80端口
EXPOSE 80

WORKDIR /home/www
