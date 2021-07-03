FROM daocloud.io/library/alpine:3.12

# 只对当前FROM中管用（如果存在.env就用.env中的，否则就用当前）
ARG CONTAINER_PACKAGE_URL=mirrors.ustc.edu.cn

# 时区设置
ARG TIME_ZONE=Asia/Shanghai

MAINTAINER <Jueluo> "chaoyue@live.com"

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 拷贝package下文件到当前工作目录
#COPY ./package/* /tmp

RUN apk add --no-cache openjdk8-jre su-exec

# 必须指定版本和插件一致
ENV VERSION 6.8.15

# https://mirrors.huaweicloud.com/elasticsearch
# oss版本可以在alpine中运行
# https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-6.8.16.zip

# es下载源地址（默认的官网太慢）
ENV DOWNLOAD_URL "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-${VERSION}.tar.gz"

# 插件源地址（默认的github太慢）
ENV PLUGIN_MIRROR "https://github.rc1844.workers.dev"

RUN apk add --no-cache bash \
    && apk add --no-cache -t .build-deps wget ca-certificates openssl \
    # 安装vim、tzdata工具
    #&& apk add --no-cache vim tzdata \
    # 设置时区
    #&& echo "${TIME_ZONE}" > /etc/timezone \
    #&& ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && set -ex \
    && cd /tmp \
    && echo "===> Install Elasticsearch..." \
    && wget --progress=bar:force -O elasticsearch.tar.gz "$DOWNLOAD_URL" && tar -xf elasticsearch.tar.gz \
    && ls -lah \
    && mv elasticsearch-$VERSION /usr/local/elasticsearch \
    && adduser -D -h /usr/local/elasticsearch elasticsearch \
    && echo "===> Creating Elasticsearch Paths..." \
    && for path in \
        /usr/local/elasticsearch/data \
        /usr/local/elasticsearch/logs \
        /usr/local/elasticsearch/config \
        /usr/local/elasticsearch/config/scripts \
        /usr/local/elasticsearch/tmp \
        /usr/local/elasticsearch/plugins \
    ; do \
    mkdir -p "$path"; \
    chown -R elasticsearch:elasticsearch "$path"; \
    done \
    # 安装ik插件
    && wget --progress=bar:force -O elasticsearch-analysis-ik.zip ${PLUGIN_MIRROR}/medcl/elasticsearch-analysis-ik/releases/download/v${VERSION}/elasticsearch-analysis-ik-${VERSION}.zip \
    && mkdir -p /usr/local/elasticsearch/plugins/analysis-ik \
    && unzip elasticsearch-analysis-ik.zip -d /usr/local/elasticsearch/plugins/analysis-ik \
    # 安装pinyin插件
    && wget --progress=bar:force -O elasticsearch-analysis-pinyin.zip ${PLUGIN_MIRROR}/medcl/elasticsearch-analysis-pinyin/releases/download/v${VERSION}/elasticsearch-analysis-pinyin-${VERSION}.zip \
    && mkdir -p /usr/local/elasticsearch/plugins/analysis-pinyin \
    && unzip elasticsearch-analysis-pinyin.zip -d /usr/local/elasticsearch/plugins/analysis-pinyin \
    # 安装腾讯云cos插件
    && wget --progress=bar:force -O repository-cos.zip ${PLUGIN_MIRROR}/tencentyun/elasticsearch-repository-cos/releases/download/v${VERSION}/repository-cos-${VERSION}.zip \
    && mkdir -p /usr/local/elasticsearch/plugins/repository-cos \
    && unzip repository-cos.zip -d /usr/local/elasticsearch/plugins/repository-cos \
    # 清除缓存
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk* \
    && apk del --purge .build-deps

COPY config/elastic /usr/local/elasticsearch/config
COPY config/logrotate /etc/logrotate.d/elasticsearch
COPY elastic-entrypoint.sh /
RUN chmod +x /elastic-entrypoint.sh
COPY docker-healthcheck /usr/local/bin/

WORKDIR /usr/local/elasticsearch

ENV PATH /usr/local/elasticsearch/bin:$PATH
ENV ES_TMPDIR /usr/local/elasticsearch/tmp

# 设置JAVA_HOME环境变量
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre

# 直接将以前编译好的文件复制到扩展目录
#COPY ./plugins /usr/local/elasticsearch/plugins

VOLUME ["/usr/local/elasticsearch/data"]

EXPOSE 9200 9300
ENTRYPOINT ["/elastic-entrypoint.sh"]
CMD ["elasticsearch"]

# HEALTHCHECK CMD ["docker-healthcheck"]
