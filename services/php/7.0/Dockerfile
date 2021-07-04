# [构建第一阶段]
FROM daocloud.io/library/php:7.0.33-fpm-alpine AS build_env

# 只对当前FROM中管用（如果存在.env就用.env中的，否则就用当前）
ARG CONTAINER_PACKAGE_URL=mirrors.ustc.edu.cn

# 时区设置
ARG TIME_ZONE=Asia/Shanghai

MAINTAINER <Jueluo> "chaoyue@live.com"

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 切换工作目录
WORKDIR /tmp

# 拷贝package下文件到当前工作目录
COPY ./package/* ./

# 拷贝package下install-php-extension文件到/usr/bin
COPY ./package/install-php-extension /usr/bin/
RUN chmod +x /usr/bin/install-php-extension

# 安装telnet、vim、git、tzdata工具
RUN apk add --update --no-cache busybox-extras vim git tzdata && pecl channel-update pecl.php.net

# 设置时区
RUN echo "${TIME_ZONE}" > /etc/timezone
RUN ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# 安装编译工具（多个RUN可以分层编译，更容易排查错误）
RUN apk add --no-cache autoconf g++ gcc libtool libc-dev make pcre-dev
RUN apk add --no-cache ca-certificates zlib-dev dpkg-dev
RUN apk add --no-cache --virtual .build-deps coreutils libedit-dev
RUN apk add --no-cache linux-headers
RUN apk add --no-cache krb5-dev openldap-dev bzip2-dev curl-dev pcre-dev
RUN apk add --no-cache libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev libxslt-dev libzip-dev
RUN apk add --no-cache librdkafka-dev rabbitmq-c rabbitmq-c-dev

# 编译安装缺少的系统扩展
RUN docker-php-ext-install -j$(nproc) bcmath bz2 calendar exif
RUN docker-php-ext-install -j$(nproc) gd ldap opcache
RUN docker-php-ext-install -j$(nproc) pcntl pdo_mysql mysqli
RUN docker-php-ext-install -j$(nproc) shmop soap
RUN docker-php-ext-install -j$(nproc) sockets sysvmsg sysvsem sysvshm xsl zip

# 编译redis扩展
RUN pecl install redis-5.3.4.tgz && docker-php-ext-enable redis

# 编译swoole扩展
RUN pecl install swoole-2.1.0.tgz && docker-php-ext-enable swoole

# 编译seaslog扩展
RUN pecl install seaslog-2.2.0.tgz && docker-php-ext-enable seaslog

# 编译yaf扩展（指定版本）
RUN pecl install yaf-3.0.4.tgz && docker-php-ext-enable yaf

# 编译yar扩展（指定版本）
RUN pecl install yar-2.0.1.tgz && docker-php-ext-enable yar

# 编译rdkafka扩展
RUN pecl install rdkafka-5.0.0.tgz && docker-php-ext-enable rdkafka

# 编译amqp扩展
RUN pecl install amqp-1.10.2.tgz && docker-php-ext-enable amqp

# 编译mcrypt扩展
#RUN pecl install mcrypt-1.0.4.tgz && docker-php-ext-enable mcrypt

# 安装imagick、memcached扩展依赖
#RUN apk add --no-cache imagemagick-dev libmemcached-dev
RUN apk add --no-cache imagemagick-dev

# 编译imagick扩展
RUN pecl install imagick-3.4.4.tgz && docker-php-ext-enable imagick

# 编译memcached扩展
#RUN pecl install memcached-3.1.5.tgz && docker-php-ext-enable memcached

# 关掉默认Opcache缓存
RUN echo "opcache.enable=Off" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
# 统一扩展文件权限
&& chmod -R +x /usr/local/lib/php/extensions/no-debug-non-zts-*/

# 删除依赖
RUN apk del -f .build-deps autoconf g++ make libtool pcre-dev
#RUN apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

# [构建第二阶段]
FROM daocloud.io/library/php:7.0.33-fpm-alpine

# 只对当前FROM中管用（如果存在.env就用.env中的，否则就用当前）
ARG CONTAINER_PACKAGE_URL=mirrors.ustc.edu.cn

# 时区设置
ARG TIME_ZONE=Asia/Shanghai

# COMPOSER镜像源
ARG COMPOSER_MIRRORS_URL=mirrors.aliyun.com

MAINTAINER <Jueluo> "chaoyue@live.com"

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi \

# 安装composer
&& curl -o /usr/bin/composer https://${COMPOSER_MIRRORS_URL}/composer/composer.phar \
&& chmod +x /usr/bin/composer \
&& /usr/bin/composer config -g repo.packagist composer https://${COMPOSER_MIRRORS_URL}/composer/ \

# 赋予SeasLog日志目录权限
&& mkdir -p /var/log/www/default && chmod -R 777 /var/log/www \

# 清除缓存
&& rm -rf /var/cache/apk* \

# 设置时区
&& echo "${TIME_ZONE}" > /etc/timezone \

# 对时区文件建立软链接
&& ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# 从编译阶段的中拷贝编译结果到当前镜像中
COPY --from=build_env /usr/lib /usr/lib
COPY --from=build_env /usr/local/php /usr/local/php
COPY --from=build_env /usr/local/lib/php /usr/local/lib/php
COPY --from=build_env /usr/local/etc/php /usr/local/etc/php
COPY --from=build_env /usr/local/include/php /usr/local/include/php
COPY --from=build_env /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# 从第一阶段复制vim到当前容器
COPY --from=build_env /usr/bin/vim /usr/bin/vim
COPY --from=build_env /usr/share/vim /usr/share/vim
COPY --from=build_env /etc/vim /etc/vim

# 从第一阶段复制git到当前容器
COPY --from=build_env /usr/bin/git /usr/bin/git
COPY --from=build_env /usr/libexec/git-core /usr/libexec/git-core
COPY --from=build_env /var/git /var/git

# 从第一阶段复制时区设置
COPY --from=build_env /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=build_env /usr/sbin/zic /usr/sbin/zic
COPY --from=build_env /usr/sbin/zdump /usr/sbin/zdump
COPY --from=build_env /usr/bin/posixtz /usr/bin/posixtz

# 从第一阶段复制busybox、telnet到当前容器
COPY --from=build_env /bin/busybox /bin/busybox
COPY --from=build_env /usr/bin/telnet /usr/bin/telnet

# 从其它镜像复制php-extension-installer到当前容器
#COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# 从第一阶段复制install-php-extension到当前容器
COPY --from=build_env /usr/bin/install-php-extension /usr/bin/install-php-extension

# 从第一阶段复制imagick extension到当前容器
COPY --from=build_env /etc/fonts /etc/fonts
COPY --from=build_env /usr/bin/MagickWand-config /usr/bin/MagickWand-config
COPY --from=build_env /usr/bin/fc-match /usr/bin/fc-match
COPY --from=build_env /usr/bin/fc-validate /usr/bin/fc-validate
COPY --from=build_env /usr/bin/Magick++-config /usr/bin/Magick++-config
COPY --from=build_env /usr/bin/fc-cache /usr/bin/fc-cache
COPY --from=build_env /usr/bin/fc-query /usr/bin/fc-query
COPY --from=build_env /usr/bin/fc-cat /usr/bin/fc-cat
#COPY --from=build_env /usr/bin/fc-conflist /usr/bin/fc-conflist
COPY --from=build_env /usr/bin/MagickCore-config /usr/bin/MagickCore-config
COPY --from=build_env /usr/bin/fc-list /usr/bin/fc-list
COPY --from=build_env /usr/bin/fc-pattern /usr/bin/fc-pattern
COPY --from=build_env /usr/bin/fc-scan /usr/bin/fc-scan

WORKDIR /home/www
