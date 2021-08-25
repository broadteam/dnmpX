#!/bin/bash
#set -e

OPENVPN_CERT_CONF='/etc/openvpn/client.conf'
TINYPROXY_CONF='/etc/tinyproxy/tinyproxy.conf'

# for openvpn
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 600 /dev/net/tun
chmod -R 777 /etc/openvpn

# 有openvpn证书时连接vpn
if [ -f $OPENVPN_CERT_CONF ]; then
  /usr/sbin/openvpn --user nobody --group nobody --daemon --config $OPENVPN_CERT_CONF
fi

# 启动tinyproxy
/usr/local/bin/tinyproxy -c $TINYPROXY_CONF

# 启动ssh
/usr/sbin/sshd -D
