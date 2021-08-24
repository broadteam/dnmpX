# [构建第一阶段]
FROM daocloud.io/library/alpine:3.12 AS build_env

# 只对当前FROM中管用（如果存在.env就用.env中的，否则就用当前）
ARG CONTAINER_PACKAGE_URL=mirrors.ustc.edu.cn

# 时区设置
ARG TIME_ZONE=Asia/Shanghai

MAINTAINER <Jueluo> "chaoyue@live.com"

# 切换工作目录
WORKDIR /tmp

# 拷贝package下文件到当前工作目录
COPY ./package/* ./

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 安装编译工具
RUN apk add --no-cache g++ gcc make \
    #&& apk add --no-cache tinyproxy \
    #&& rm -rf /etc/tinyproxy/* \

    #&& wget https://github.com/tinyproxy/tinyproxy/releases/download/1.11.0/tinyproxy-1.11.0.tar.gz \

    && tar xf tinyproxy-*.tar.gz && cd tinyproxy-* \
    && ./configure && make && make install

# [构建第二阶段]
FROM daocloud.io/library/alpine:3.12

# 只对当前FROM中管用（如果存在.env就用.env中的，否则就用当前）
ARG CONTAINER_PACKAGE_URL=mirrors.ustc.edu.cn

# 时区设置
ARG TIME_ZONE=Asia/Shanghai

# COMPOSER镜像源
ARG COMPOSER_MIRRORS_URL=mirrors.aliyun.com

MAINTAINER <Jueluo> "chaoyue@live.com"

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi \

# 安装vim、telnet、tzdata等开发工具
&& apk add --update --no-cache vim busybox-extras tzdata curl \

# 清除缓存
&& rm -rf /var/cache/apk* \

# 设置时区
&& echo "${TIME_ZONE}" > /etc/timezone \

# 对时区文件建立软链接
&& ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# 从编译阶段的中拷贝编译结果到当前镜像中
COPY --from=build_env /usr/local/bin/tinyproxy /usr/local/bin/tinyproxy
COPY --from=build_env /usr/local/etc/tinyproxy/tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

# 拷贝启动文件到根目录对应的文件夹
COPY systemd/ /

# 对拷贝过来的文件赋予执行权限
RUN chmod -v +x /etc/cont-init.d/* /etc/services.d/*/run \

# 创建配置目录
&& mkdir -p /usr/local/etc/tinyproxy \

# 创建软链接
&& ln -s /etc/tinyproxy/tinyproxy.conf /usr/local/etc/tinyproxy/tinyproxy.conf \

# 修改tinyproxy配置
&& sed -i "s/Allow 127/\#Allow 127/g" /etc/tinyproxy/tinyproxy.conf && sed -i "s/Allow :/\#Allow :/g" /etc/tinyproxy/tinyproxy.conf

#CMD [ "tinyproxy", "/etc/tinyproxy/tinyproxy.conf" ]

# 对外暴露8888端口
EXPOSE 8888
