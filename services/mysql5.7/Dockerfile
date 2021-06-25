FROM daocloud.io/library/mysql:5.7.31

MAINTAINER <Jueluo> "chaoyue@live.com"

# 只对当前FROM中管用（如果存在.env就用.env中的，否则就用当前）
ARG MYSQL_ROOT_PASSWORD=123456

# 定义环境变量
ENV MYSQL_ROOT_PASSWORD ${MYSQL_ROOT_PASSWORD}

# 国内debian源
ADD ./mirrors/debian/sources.list /etc/apt/

# 调整sh为bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# 对外暴露3306端口
EXPOSE 3306
