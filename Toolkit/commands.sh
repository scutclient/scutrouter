uci set system.@system[0].hostname=SCUT 
uci set system.@system[0].timezone=HKT-8 
uci set system.@system[0].zonename=Asia/Hong Kong 
uci set network.wan.macaddr=54:A0:50:E8:1C:21  
uci set network.wan.proto=static 
uci set network.wan.ipaddr=1.1.1.1  
uci set network.wan.netmask=1.1.1.1  
uci set network.wan.gateway=1.1.1.1 
uci set network.wan.dns=202.112.17.33 114.114.114.114 
uci set wireless.@wifi-device[0].disabled=0  
uci set wireless.@wifi-iface[0].mode=ap  
uci set wireless.@wifi-iface[0].ssid=QQgroup:262939451   
uci set wireless.@wifi-iface[0].encryption=psk2  
uci set wireless.@wifi-iface[0].key=11111111   
uci commit  
opkg install /tmp/setup_ipk/libpcap_1.3.0-1_ar71xx.ipk 
opkg install /tmp/setup_ipk/scutclient_1.3-1_ar71xx.ipk 
echo sleep 30 > /etc/rc.local 
echo scutclient 1 1 & > /etc/rc.local 
echo exit 0 > /etc/rc.local 
01 06 * * 1-5 killall scutclient > /etc/crontabs/root 
02 06 * * 1-5 scutclient 1 1 & > /etc/crontabs/root 
00 12 * * 0-7 ntpd ¨Cn ¨Cd ¨Cp s2g.time.edu.cn > /etc/crontabs/root 
