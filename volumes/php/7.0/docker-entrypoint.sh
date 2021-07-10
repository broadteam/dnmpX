#!/bin/bash
#n=1
#echo "websocket服务是否启动"
#while true
#do
#    if test $n -gt 20
#    then
#        echo "websocket服务启动失败"
#        break
#    fi
#    sleep 5
#    n=$(($n+1))
#    port=`netstat -antp | grep "0.0.0.0:2121"`      #端口
#    if [ ${#port} -gt 3 ]; then
#        echo "websocket服务已经启动"
#        break;
#    fi
#done

#port=`lsof -i:2121 | wc -l`
port=`netstat -antp | grep "0.0.0.0:2121"`

if [ ${#port} -gt 3 ];then
    echo "websocket服务已经启动"
else
    echo "websocket服务未启动，启动中"
    php /home/www/websocket/wwwroot/start.php start -d
fi
