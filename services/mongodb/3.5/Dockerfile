FROM daocloud.io/library/mongo:3.5.12

MAINTAINER <Jueluo> "chaoyue@live.com"

# 只对当前FROM中管用（如果存在.env就用.env中的，否则就用当前）
ARG CONTAINER_PACKAGE_URL=mirrors.ustc.edu.cn

# 时区设置
ARG TIME_ZONE=Asia/Shanghai

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 安装vim、telnet、tzdata等开发工具
RUN apk add --update --no-cache vim busybox-extras tzdata \

# 设置时区
&& echo "${TIME_ZONE}" > /etc/timezone \
# 对时区文件建立软链接
&& ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \

# 清除缓存
&& rm -rf /var/cache/apk*
