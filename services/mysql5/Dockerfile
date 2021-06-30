FROM daocloud.io/library/alpine:3.9

# 只对当前FROM中管用（如果存在.env就用.env中的，否则就用当前）
ARG CONTAINER_PACKAGE_URL=mirrors.ustc.edu.cn

# 时区设置
ARG TIME_ZONE=Asia/Shanghai

MAINTAINER <Jueluo> "chaoyue@live.com"

# 更新为国内镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 切换工作目录
WORKDIR /tmp

# 拷贝soft下文件到当前工作目录
COPY ./package/* ./

# 安装开发工具包alpine-sdk
#RUN apk add --update --no-cache cmake gcc gcc-c++ alpine-sdk ncurses ncurses-dev
RUN apk add --update --no-cache alpine-sdk ncurses ncurses-dev
RUN addgroup mysql
RUN adduser mysql -G mysql -s /sbin/nologin -D
RUN mkdir -p /usr/local/mysql
RUN chown -R mysql:mysql /usr/local/mysql

# 编译mysql依赖此包
#RUN tar zxf ./ncurses.tar.gz
#RUN cd ncurses*
#RUN ./ncurses*/configure && make && make install
#RUN rm -rf ncurses*

RUN wget https://cdn.mysql.com/archives/mysql-5.6/mysql-5.6.40.tar.gz
RUN tar -zxvf mysql-5.6.40.tar.gz -C /usr/local/mysql
RUN rm -rf mysql-5.6.40.tar.gz
RUN rm -rf /tmp/* && cd /usr/local/mysql && pwd

RUN cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
  -DMYSQL_DATADIR=/usr/local/mysql/data \
  -DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
  -DMYSQL_TCP_PORT=3306 \
  -DDEFAULT_CHARSET=utf8 \
  -DDEFAULT_COLLATION=utf8_general_ci \
  -DWITH_EXTRA_CHARSETS=all \
  -DWITH_INNOBASE_STORAGE_ENGINE=1 \
  -DWITH_FEDERATED_STORAGE_ENGINE=1 \
  -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
  -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
  -DWITH_ZLIB=bundled \
  -DWITH_SSL=bundled \
  -DFORCE_INSOURCE_BUILD=1 \
  -DENABLED_LOCAL_INFILE=1 \
  -DWITH_EMBEDDED_SERVER=1 \
  -DENABLE_DOWNLOADS=1 \
  -DWITH_DEBUG=0

RUN make && make install

RUN echo -e "[client]\ndefault-character-set=utf8\n" \
"socket=/usr/local/mysql/tmp/mysql.sock\n\n" \
"[mysql]\ndefault-character-set=utf8\n" \
"[mysqld]\nsocket=/usr/local/mysql/tmp/mysql.sock\n" \
"tmpdir=/usr/local/mysql/tmp/\n" \
"basedir=/usr/local/mysql\n" \
"datadir=/usr/local/mysql/data\n" \
"symbolic-links=0\n" \
"character_set_server=utf8\n" \
"[mysqld_safe]\n" \
"default-character-set=utf8\n" \
"log-error=/usr/local/mysql/logs/mysqld.log\n" \
"pid-file=/usr/local/mysql/run/mysqld/mysqld.pid\n">my.cnf

RUN chmod 644 my.cnf

#建立临时文件，日志存储文件目录
RUN mkdir -p tmp logs run/mysqld

RUN scripts/mysql_install_db --user=mysql --defaults-file=/usr/local/mysql/my.cnf --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data/
