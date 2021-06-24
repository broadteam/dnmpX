FROM daocloud.io/library/php:7.4.10-fpm-alpine

MAINTAINER <Jueluo chaoyue@live.com>

ARG CONTAINER_PACKAGE_URL

WORKDIR /usr/src
COPY ./soft/* ./

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 安装telnet工具
RUN apk add busybox-extras

# 安装编译工具
#apk add --no-cache autoconf gcc g++ libtool make curl-dev zlib-dev libxml2-dev linux-headers libmcrypt
RUN apk add autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c \
&& apk add vim busybox-extras \
&& apk add --no-cache ca-certificates curl tar xz openssl \
&& apk add --no-cache --virtual .build-deps argon2-dev coreutils curl-dev \
&& apk add linux-headers oniguruma-dev openssl-dev sqlite-dev \
&& apk add krb5-dev \
&& apk add bzip2-dev libedit-dev libsodium-dev libxml2-dev libpng-dev libwebp-dev libjpeg libjpeg-turbo-dev freetype-dev gettext-dev libxslt-dev libzip-dev

# 编译安装缺少的系统扩展
&& docker-php-ext-install -j$(nproc) bcmath calendar exif gettext sockets dba mysqli pcntl pgsql pdo_mysql pdo_pgsql shmop sysvmsg sysvsem sysvshm soap wddx xmlrpc tidy xsl zip \

# 编译redis扩展
&& pecl install redis-5.3.4.tgz \
&& touch /usr/local/etc/php/conf.d/redis.ini \
&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \

# 编译swoole扩展
&& pecl install swoole-4.6.4.tgz \
&& touch /usr/local/etc/php/conf.d/swoole.ini \
&& echo "extension=swoole.so" > /usr/local/etc/php/conf.d/swoole.ini \

# 编译msgpack扩展
#&& pecl install msgpack-2.1.2.tgz \
#&& touch /usr/local/etc/php/conf.d/msgpack.ini \
#&& echo "extension=msgpack.so" > /usr/local/etc/php/conf.d/msgpack.ini \

# 编译seaslog扩展
#&& pecl install SeasLog-2.2.0.tgz \
#&& touch /usr/local/etc/php/conf.d/seaslog.ini \
#&& echo "extension=seaslog.so" > /usr/local/etc/php/conf.d/seaslog.ini \

# 编译yaf扩展
&& pecl install yaf-3.3.2.tgz \
&& touch /usr/local/etc/php/conf.d/yaf.ini \
&& echo "extension=yaf.so" > /usr/local/etc/php/conf.d/yaf.ini \

# 编译yar扩展
&& pecl install yar-2.2.0.tgz \
&& touch /usr/local/etc/php/conf.d/yar.ini \
&& echo "extension=yar.so" > /usr/local/etc/php/conf.d/yar.ini \

# 编译yaconf扩展
#&& pecl install yaconf-1.1.0.tgz \
#&& touch /usr/local/etc/php/conf.d/yaconf.ini \
#&& echo "extension=yaconf.so" > /usr/local/etc/php/conf.d/yaconf.ini \

# 编译xdebug扩展
#&& pecl install xdebug-3.0.3.tgz \
#&& touch /usr/local/etc/php/conf.d/xdebug.ini \
#&& echo "extension=xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini \

# 编译amqp扩展（需要指定rabbitmq安装目录）
#&& pecl install amqp-1.10.2.tgz \
#&& touch /usr/local/etc/php/conf.d/amqp.ini \
#&& echo "extension=amqp.so" > /usr/local/etc/php/conf.d/amqp.ini \

# 编译imagick扩展
#&& pecl install imagick-3.4.4.tgz \
#&& touch /usr/local/etc/php/conf.d/imagick.ini \
#&& echo "extension=imagick.so" > /usr/local/etc/php/conf.d/imagick.ini \

# 编译memcached扩展
#&& pecl install memcached-3.1.5.tgz \
#&& touch /usr/local/etc/php/conf.d/memcached.ini \
#&& echo "extension=memcached.so" > /usr/local/etc/php/conf.d/memcached.ini \

# 编译xhprof扩展
#&& pecl install xhprof-2.3.0.tgz \
#&& touch /usr/local/etc/php/conf.d/xhprof.ini \
#&& echo "extension=xhprof.so" > /usr/local/etc/php/conf.d/xhprof.ini \

# 删除安装包
&& rm -rf ./* \

# 清除缓存
&& rm -rf /var/cache/apk*

WORKDIR /var/www/html

# 对外暴露9000端口
EXPOSE 9074
