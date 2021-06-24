FROM daocloud.io/library/php:7.0.33-fpm-alpine

MAINTAINER <Jueluo chaoyue@live.com>

ARG CONTAINER_PACKAGE_URL

# 设置变量
#ENV REDIS_EXT_VERSION=5.3.4 YAF_EXT_VERSION=3.0.4 YAR_EXT_VERSION=2.0.1

WORKDIR /usr/src
COPY ./soft/* ./

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 安装telnet工具
RUN apk add busybox-extras

# 安装编译工具
#apk add --no-cache autoconf gcc g++ libtool make curl-dev zlib-dev libxml2-dev linux-headers libmcrypt
RUN apk add --no-cache autoconf g++ make curl-dev \

# 编译安装缺少的系统扩展
&& docker-php-ext-install -j$(nproc) bcmath calendar exif gettext sockets dba mysqli pcntl pgsql pdo_mysql pdo_pgsql shmop sysvmsg sysvsem sysvshm soap wddx xmlrpc tidy xsl zip \

# 编译redis扩展
&& pecl install redis-5.3.4.tgz \
&& touch /usr/local/etc/php/conf.d/redis.ini \
&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \

# 编译yaf扩展
&& pecl install yaf-3.0.4.tgz \
&& touch /usr/local/etc/php/conf.d/yaf.ini \
&& echo "extension=yaf.so" > /usr/local/etc/php/conf.d/yaf.ini \

# 编译yar扩展
&& pecl install yar-2.0.1.tgz \
&& touch /usr/local/etc/php/conf.d/yar.ini \
&& echo "extension=yar.so" > /usr/local/etc/php/conf.d/yar.ini \

# 删除安装包
&& rm -rf ./* \

# 清除缓存
&& rm -rf /var/cache/apk*

WORKDIR /var/www/html

# 对外暴露9000端口
EXPOSE 9070
