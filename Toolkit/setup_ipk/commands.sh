opkg remove luci-app-scutclient
opkg remove scutclient
opkg install /tmp/setup_ipk/*.ipk
uci set system.@system[0].hostname='SCUT'
uci set system.@system[0].timezone='HKT-8'
uci set system.@system[0].zonename='Asia/Hong Kong'
uci set luci.languages.zh_cn='chinese'
uci set network.wan.macaddr='54:A0:50:E8:1C:21 '
uci set network.wan.proto='static'
uci set network.wan.ipaddr='10.10.10.11'
uci set network.wan.netmask='255.255.255.0'
uci set network.wan.gateway='10.10.10.1'
uci set network.wan.dns='202.112.17.33 114.114.114.114'
uci set wireless.@wifi-device[0].disabled='0'
uci set wireless.@wifi-iface[0].mode='ap'
uci set wireless.@wifi-iface[0].ssid='Test'
uci set wireless.@wifi-iface[0].encryption='psk2'
uci set wireless.@wifi-iface[0].key='123QWEqwe'
uci set scutclient.@option[0].boot='1'
uci set scutclient.@option[0].enable='1'
uci set scutclient.@scutclient[0]='scutclient'
uci set scutclient.@scutclient[0].interface=$(uci get network.wan.ifname)
uci set scutclient.@scutclient[0].username='2010'
uci set scutclient.@scutclient[0].password='2010'
uci commit
echo sleep 30 > /etc/rc.local
echo scutclient 2010 2010 \& >> /etc/rc.local
echo sleep 30 >> /etc/rc.local
echo ntpd -n -d -p s2g.time.edu.cn >> /etc/rc.local
echo exit 0 >> /etc/rc.local
echo 01 06 * * 1-5 killall scutclient > /etc/crontabs/root
echo 05 06 * * 1-5 scutclient 2010 2010 \& >> /etc/crontabs/root
echo 00 12 * * 0-7 ntpd -n -d -p s2g.time.edu.cn >> /etc/crontabs/root
reboot
