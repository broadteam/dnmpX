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

# 安装bash、vim、telnet、tzdata等开发工具
&& apk add --update --no-cache bash vim busybox-extras tzdata curl \

# 安装openvpn、ssh
&& apk add --update --no-cache openvpn openssh \

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
RUN chmod -v +x /etc/cont-init.d/* /etc/services.d/* \

# 创建tinyproxy配置目录、日志目录
&& mkdir -p /usr/local/etc/tinyproxy && mkdir -p /var/log/tinyproxy \

# 设置权限
&& chmod -R 777 /var/log/tinyproxy \

# 创建软链接
&& ln -s /etc/tinyproxy/tinyproxy.conf /usr/local/etc/tinyproxy/tinyproxy.conf \

# 修改tinyproxy配置
&& sed -i "s/Allow 127/#Allow 127/g" /etc/tinyproxy/tinyproxy.conf \
&& sed -i "s/Allow :/#Allow :/g" /etc/tinyproxy/tinyproxy.conf \
&& sed -i "s/#LogFile/LogFile/g" /etc/tinyproxy/tinyproxy.conf \
&& sed -i "s/#BasicAuth user password/BasicAuth root 123456/g" /etc/tinyproxy/tinyproxy.conf \

# 修改ssh配置
&& sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
   ssh-keygen -t dsa -P "" -f /etc/ssh/ssh_host_dsa_key && \
   ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key && \
   ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key && \
   ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key && \
   # 修改root密码为123456
   echo "root:123456" | chpasswd

# 执行ssh启动命令
CMD ["/etc/services.d/startup.sh", "-d"]

# 对外暴露8888/22端口
EXPOSE 22
EXPOSE 8888
