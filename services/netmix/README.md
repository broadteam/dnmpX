## CloudMix

> CloudMix is a light-weight HTTP/HTTPS proxy daemon for POSIX operating systems. Designed from the ground up to be fast and yet small, it is an ideal solution for use cases such as embedded deployments where a full featured HTTP proxy is required, but the system resources for a larger proxy are unavailable

### Usage

```
docker run --privileged=true --cap-add=NET_ADMIN --name netmix -p 8888:8888 -p 2222:22 -v "/data/netmix/config/tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf" -v "/data/netmix/config/sshd_config:/etc/ssh/sshd_config" -v "/data/netmix/config/openvpn.conf:/etc/openvpn/client.conf" netmix
```

#### Environment

 - `LISTEN_PORT`: Change the port tinyproxy uses. Handy if running with `--net host`. Defaults to `8888`
 - `ALLOWED`: Space seperated list of IPs, networks or hosts to allow access through the proxy
 - `CONNECT_PORTS`: This option can be used to specify the ports allowed for the CONNECT method. Default 443 and 563
 - `LOG_TO_SYSLOG`: When set to On, this option tells CloudMix to write its debug messages to syslog. Defaults to On
 - `LOG_LEVEL`: Sets the log level. Possible values are `Critical` (least verbose), `Error`, `Warning`, `Notice`, `Connect` (log connections without Info's noise), `Info` (most verbose). Defaults to Notice
 - `MAXCLIENTS`: CloudMix creates one child process for each connected client. This options specifies the absolute highest number processes that will be created
 - `MINSPARESERVERS` & `MAXSPARESERVERS`: Minimum and maximum number of spare servers to keep running. Defaults to 10 and 20 respectively
 - `STARTSERVERS`: The number of servers to start initially. Defaults to 10.

### Advanced configuration

If you need a more advanced configuration, create a tinyproxy.conf outside the Docker container and use it inside:

```
docker run --name netmix -p 8888:8888 -p 2222:22 -v "/data/netmix/tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf" -v "/data/netmix/sshd_config:/etc/ssh/sshd_config" netmix:1.0
```
