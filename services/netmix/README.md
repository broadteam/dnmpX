## netMix

> 主要解决vpn连接服务器时，连接远程服务器，像在一个局域网一样操作网络，连接服务器等，更多功能，自己发掘吧！

本项目依赖于docker!

### 编译方法

```
docker build -t netmix:latest ./
```

### 启动服务

```bash
# 特权用户运行（权限全开，不利于宿主机安全）
--privileged=true

# 细粒度权限设置，需要什么开什么
--cap-drop
--cap-add=NET_ADMIN #允许执行网络管理任务

# CAP_CHOWN:修改文件属主的权限
# CAP_DAC_OVERRIDE:忽略文件的DAC访问限制
# CAP_DAC_READ_SEARCH:忽略文件读及目录搜索的DAC访问限制
# CAP_FOWNER：忽略文件属主ID必须和进程用户ID相匹配的限制
# CAP_FSETID:允许设置文件的setuid位
# CAP_KILL:允许对不属于自己的进程发送信号
# CAP_SETGID:允许改变进程的组ID
# CAP_SETUID:允许改变进程的用户ID
# CAP_SETPCAP:允许向其他进程转移能力以及删除其他进程的能力
# CAP_LINUX_IMMUTABLE:允许修改文件的IMMUTABLE和APPEND属性标志
# CAP_NET_BIND_SERVICE:允许绑定到小于1024的端口
# CAP_NET_BROADCAST:允许网络广播和多播访问
# CAP_NET_ADMIN:允许执行网络管理任务
# CAP_NET_RAW:允许使用原始套接字
# CAP_IPC_LOCK:允许锁定共享内存片段
# CAP_IPC_OWNER:忽略IPC所有权检查
# CAP_SYS_MODULE:允许插入和删除内核模块
# CAP_SYS_RAWIO:允许直接访问/devport,/dev/mem,/dev/kmem及原始块设备
# CAP_SYS_CHROOT:允许使用chroot()系统调用
# CAP_SYS_PTRACE:允许跟踪任何进程
# CAP_SYS_PACCT:允许执行进程的BSD式审计
# CAP_SYS_ADMIN:允许执行系统管理任务，如加载或卸载文件系统、设置磁盘配额等
# CAP_SYS_BOOT:允许重新启动系统
# CAP_SYS_NICE:允许提升优先级及设置其他进程的优先级
# CAP_SYS_RESOURCE:忽略资源限制
# CAP_SYS_TIME:允许改变系统时钟
# CAP_SYS_TTY_CONFIG:允许配置TTY设备
# CAP_MKNOD:允许使用mknod()系统调用
# CAP_LEASE:允许修改文件锁的FL_LEASE标志
```

启动：

桥接模式：

```
docker run -d --name netmix --cap-add=NET_ADMIN --hostname netmix --net=bridge -p 8888:8888 -p 2222:22 -v "/data/netmix/config/tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf" -v "/data/netmix/config/sshd_config:/etc/ssh/sshd_config" -v "/data/netmix/config/openvpn.conf:/etc/openvpn/client.conf" netmix:latest
```

host模式：

```
docker run -d --name netmix --cap-add=NET_ADMIN --hostname netmix --net=host -p 8888:8888 -p 2222:22 -v "/data/netmix/config/tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf" -v "/data/netmix/config/sshd_config:/etc/ssh/sshd_config" -v "/data/netmix/config/openvpn.conf:/etc/openvpn/client.conf" netmix:latest
```
--net network_my --ip 192.168.10.30
