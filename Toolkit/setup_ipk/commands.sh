opkg remove luci-app-scutclient
opkg remove scutclient
opkg install /tmp/setup_ipk/*.ipk
uci set system.@system[0].hostname='SCUT'
uci set system.@system[0].timezone='HKT-8'
uci set system.@system[0].zonename='Asia/Hong Kong'
uci set luci.languages.zh_cn='chinese'
uci set network.wan.proto='static'
uci set network.wan.dns='202.112.17.33 114.114.114.114'
uci set wireless.@wifi-device[0].disabled='0'
uci set wireless.@wifi-iface[0].mode='ap'
uci set wireless.@wifi-iface[0].encryption='psk2'
uci set scutclient.@option[0].boot='1'
uci set scutclient.@option[0].enable='1'
uci set scutclient.@scutclient[0]='scutclient'
uci commit
echo 01 06 * * 1-5 killall scutclient > /etc/crontabs/root
echo 05 06 * * 1-5 scutclient $(uci get scutclient.@scutclient[0].username) $(uci get scutclient.@scutclient[0].password) \& >> /etc/crontabs/root
echo 00 12 * * 0-7 ntpd -n -d -p s2g.time.edu.cn >> /etc/crontabs/root
reboot
