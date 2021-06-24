FROM daocloud.io/library/php:7.0.33-fpm-alpine

MAINTAINER <Jueluo chaoyue@live.com>

ARG CONTAINER_PACKAGE_URL

# 直接将以前编译好的文件复制到扩展目录
COPY extension/* /usr/local/lib/php/extensions/no-debug-non-zts-20151012/

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 安装vim、telnet等开发工具
RUN apk add --no-cache autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c \
&& apk add --no-cache vim busybox-extras \
&& apk add --no-cache curl tar xz openssl coreutils curl-dev \
&& apk add --no-cache linux-headers oniguruma-dev openssl-dev sqlite-dev \
&& apk add --no-cache krb5-dev \
&& apk add --no-cache bzip2-dev libedit-dev libsodium-dev libxml2-dev libpng-dev libwebp-dev libjpeg libjpeg-turbo-dev freetype-dev gettext-dev libxslt-dev libzip-dev

# 配置gd扩展
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
# 编译安装缺少的系统扩展
&& docker-php-ext-install bcmath gd gettext mysqli opcache pcntl pdo pdo_mysql shmop soap sockets sysvsem xmlrpc xsl zip \

# 直接将以前编译好的文件复制到扩展目录
&& touch /usr/local/etc/php/conf.d/redis.ini \
&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \

# 编译yaf扩展
&& touch /usr/local/etc/php/conf.d/yaf.ini \
&& echo "extension=yaf.so" > /usr/local/etc/php/conf.d/yaf.ini \

# 编译yar扩展
&& touch /usr/local/etc/php/conf.d/yar.ini \
&& echo "extension=yar.so" > /usr/local/etc/php/conf.d/yar.ini

# 安装composer
RUN curl -o /usr/bin/composer https://mirrors.aliyun.com/composer/composer.phar \

&& chmod +x /usr/bin/composer \
&& /usr/bin/composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \

# for seaslog
&& mkdir -p /var/log/www/default && chmod -R 777 /var/log/www \

# 清除缓存
&& rm -rf /var/cache/apk*

# 对外暴露9000端口
#EXPOSE 9000

WORKDIR /home/www
