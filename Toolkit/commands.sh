uci set network.wan.macaddr=54:A0:50:E8:1C:21  
uci set network.wan.proto=static 
uci set network.wan.ipaddr=1.1.1.1  
uci set network.wan.netmask=1.1.1.1  
uci set network.wan.gateway=1.1.1.1 
uci set network.wan.dns=202.112.17.33 114.114.114.114 
uci set wireless.@wifi-device[0].disabled=0  
uci set wireless.@wifi-iface[0].mode=ap  
uci set wireless.@wifi-iface[0].ssid=Test
uci set wireless.@wifi-iface[0].encryption=psk2  
uci set wireless.@wifi-iface[0].key=123QWEqwe
uci commit  
ifup wan  
/etc/init.d/network restart   
