FROM alpine:3.10

MAINTAINER <Jueluo> "chaoyue@live.com"

# 只对当前FROM中管用（如果存在.env就用.env中的，否则就用当前）
ARG CONTAINER_PACKAGE_URL=mirrors.ustc.edu.cn

# 时区设置
ARG TIME_ZONE=Asia/Shanghai

RUN apk add --no-cache dnsmasq

# Running as root does not require NET_ADMIN capability
RUN echo 'user=root' >> /etc/dnsmasq.conf

ENTRYPOINT ["/usr/sbin/dnsmasq", "--no-daemon"]
