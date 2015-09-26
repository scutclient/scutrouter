@echo off & setlocal enabledelayedexpansion
color 1A
TITLE 一键设置路由器脚本  --华工路由器正式群出品
set routerPasswd=admin
pushd "%CD%"
CD /D "%~dp0"
echo ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
echo ◇◇◆◇◇◇◇◆◆◆◆◆◇◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◇◇
echo ◇◇◆◆◇◇◇◆◇◇◇◆◇◇◇◇◇◆◇◇◆◇◇◇◆◇◇◆◇◇
echo ◇◇◇◆◆◇◇◆◇◇◇◆◇◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◇◇
echo ◇◆◆◆◇◇◆◆◇◇◇◆◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◇
echo ◇◇◆◆◇◆◆◆◇◇◇◆◆◆◇◇◇◇◇◇◇◆◆◇◇◇◇◇◇◇
echo ◇◇◇◆◇◇◆◆◆◆◆◆◆◇◇◇◇◇◆◆◆◆◆◆◆◆◆◇◇◇
echo ◇◇◇◆◇◇◇◆◆◇◇◆◆◇◇◇◇◇◆◆◆◆◆◆◆◆◆◇◇◇
echo ◇◇◇◆◇◇◇◆◆◇◆◆◇◇◇◇◇◇◆◇◇◇◇◇◇◇◆◇◇◇
echo ◇◇◇◆◇◆◆◇◆◆◆◆◇◇◇◇◇◇◆◆◆◆◆◆◆◆◆◇◇◇
echo ◇◇◇◆◆◆◆◇◆◆◆◇◇◇◇◇◇◇◆◆◆◆◆◆◆◆◆◇◇◇
echo ◇◇◇◆◆◆◆◆◆◆◆◆◆◇◇◇◇◇◆◇◇◇◇◇◇◇◆◇◇◇
echo ◇◇◇◆◆◆◆◆◇◇◇◆◆◆◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◇
echo ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
echo.&echo =========================================================
echo 	本脚本由#华工路由器正式群#提供
echo 	注意：登陆路由器密码必须为%routerPasswd%，否则必然失败
echo.&echo =========================================================
echo.
echo 提示：脚本将会把你连接路由的网卡设置IP，DNS为自动获得（如果不成功，那就自己设置有线网卡为自动获得后再次执行该脚本）
echo 如果下面列表里出现一个TAP-Win32 XX VXX的东西，那个不是你有线网卡，有线网卡一般带Intel、Realtek、Atheros、Nvidia、Broadcom、Marvell等厂商字样
pause
call ChangeIP.bat 2
echo 提示：已经将你连接路由的网卡设置IP，DNS为自动获得
pause
:_PING
ping OpenWrt
IF %errorlevel% EQU 0 ( goto _CONTINUE ) else ( goto NO_OPENWRT )
pause
:NO_OPENWRT
echo 该系统可能为非OPENWRT官方系统（或者是不是用OpenWrt做主机名），不适宜继续执行脚本，如果已经确定是OpenWrt系统可以继续
pause
echo.
ping -a 192.168.1.1
IF %errorlevel% EQU 0 ( goto _CONTINUE ) else ( goto _FAIL )
:_CONTINUE
echo 输入你的上网信息，每项信息输入后按回车即可下一步操作
set /p User=拨号用的用户名(其实就是学号)：  
set /p Password=拨号用的密码（如果不清楚请咨询网络中心）:  
set /p SSID=你自己想要的的WIFI名字（只能英文或者数字跟符号混搭）:  
set /p Key=路由器的WIFI密码（最少8位，只能英文或者数字跟符号混搭）:  
:MAC_LOOP
echo.&echo ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
echo.&echo  选择要应用到路由器的MAC，请根据你在学校登记情况选择相应的MAC地址
set /A N=0
for /f "skip=1 tokens=1,* delims= " %%a in ('wmic nic where AdapterTypeId^="0" get name^,macaddress') do ( if "%%b" == "" ( @echo off ) else (set /A N+=1&set _!N!MAC=%%a&call echo.[!N!] %%b %%a) )
set /A N+=1
echo [%N%] 不是用这个电脑在学校登记的，要填其他MAC地址（格式大写字母XX:XX:XX:XX:XX:XX)  
echo.&echo ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
echo.
set /p input=选择上面要应用的MAC地址，输入列表序号中的数字就行，如果都没有请选择[%N%]:
IF %input% EQU %N% (goto DIY_MAC) ELSE (set MACaddress=!_%input%MAC! & goto MAC_END)
:DIY_MAC
echo.
set /p MACaddress=填写你提供给学校的MAC地址,切英文状态输入法输入:  
:MAC_END
checkMAC.bat %MACaddress%|findstr error && goto MAC_LOOP || goto _MAC_OK
:_MAC_OK
echo.
set /p IPaddress=填写学校给你的IP地址(格式X.X.X.X):  
checkIP.bat %IPaddress%|findstr error && goto _MAC_OK || goto _IP_OK
:_IP_OK
echo.
set /p Mask=填写学校给你的子网掩码(格式X.X.X.X):  
checkIP.bat %Mask%|findstr error && goto _IP_OK || goto _MASK_OK
:_MASK_OK
echo.
set /p Gateway=填写学校给你的网关地址(格式X.X.X.X):  
checkIP.bat %Gateway%|findstr error && goto _IP_OK || goto _GATEWAY_OK
:_GATEWAY_OK
echo.
echo 提示：准备telnet路由开通SSH，把密码改为%routerPasswd%,如果出现FATAL ERROR: Network error: Connection refused 也不用理会
pause
echo (echo %routerPasswd% ^&^& echo %routerPasswd%) ^> pass.log ^&^& (passwd ^< pass.log ^&^& rm -f pass.log) ^&^& exit > telnet.sh
type telnet.sh|plink -telnet root@192.168.1.1
cd.>telnet.sh
echo.
echo 提示：准备传送setup_ipk文件夹到路由的/tmp/下面
pause
echo opkg remove luci-app-scutclient> %~dp0setup_ipk\commands.sh
echo opkg remove scutclient>> %~dp0setup_ipk\commands.sh
echo opkg install /tmp/setup_ipk/*.ipk>> %~dp0setup_ipk\commands.sh
echo uci set system.@system[0].hostname='SCUT'>> %~dp0setup_ipk\commands.sh
echo uci set system.@system[0].timezone='HKT-8'>> %~dp0setup_ipk\commands.sh
echo uci set system.@system[0].zonename='Asia/Hong Kong'>> %~dp0setup_ipk\commands.sh
echo uci set luci.languages.zh_cn='chinese'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.macaddr='%MACaddress%'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.proto='static'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.ipaddr='%IPaddress%'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.netmask='%Mask%'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.gateway='%Gateway%'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.dns='202.112.17.33 114.114.114.114'>> %~dp0setup_ipk\commands.sh
echo uci set wireless.@wifi-device[0].disabled='0'>> %~dp0setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].mode='ap'>> %~dp0setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].ssid='%SSID%'>> %~dp0setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].encryption='psk2'>> %~dp0setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].key='%Key%'>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@option[0].boot='1'>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@option[0].enable='1'>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0]='scutclient'>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0].interface=$(uci get network.wan.ifname)>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0].username='%User%'>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0].password='%Password%'>> %~dp0setup_ipk\commands.sh
echo uci commit>> %~dp0setup_ipk\commands.sh
echo echo sleep 30 ^> /etc/rc.local>> %~dp0setup_ipk\commands.sh
echo echo killall scutclient^>^> /etc/rc.local>> %~dp0switch\commands.sh
echo echo scutclient %User% %Password% \^& ^>^> /etc/rc.local>> %~dp0setup_ipk\commands.sh
echo echo sleep 30 ^>^> /etc/rc.local>> %~dp0setup_ipk\commands.sh
echo echo ntpd -n -d -p s2g.time.edu.cn ^>^> /etc/rc.local>> %~dp0setup_ipk\commands.sh
echo echo exit 0 ^>^> /etc/rc.local>> %~dp0setup_ipk\commands.sh
echo echo 01 06 * * 1-5 killall scutclient ^> /etc/crontabs/root>> %~dp0setup_ipk\commands.sh
echo echo 05 06 * * 1-5 scutclient %User% %Password% \^& ^>^> /etc/crontabs/root>> %~dp0setup_ipk\commands.sh
echo echo 00 12 * * 0-7 ntpd -n -d -p s2g.time.edu.cn ^>^> /etc/crontabs/root>> %~dp0setup_ipk\commands.sh
echo reboot>> %~dp0setup_ipk\commands.sh
echo.
echo 提示：已经生成commands.sh脚本
pause
echo y|pscp -scp -P 22 -pw %routerPasswd%  -r ./setup_ipk root@192.168.1.1:/tmp/ | findstr 100% && echo OK || goto _FAIL
echo 提示：准备在路由执行commands.sh脚本
pause
echo y|plink -P 22 -pw %routerPasswd% root@192.168.1.1 "sed -i 's/\r//g;' /tmp/setup_ipk/commands.sh && chmod 755 /tmp/setup_ipk/commands.sh && /tmp/setup_ipk/commands.sh"
echo 提示：自动配置成功，请现在拔路由器电源然后再插上(重启路由)，等弹出的网页能访问就代表启动完成了
echo 以后换帐号，换ip,MAC等等情况都可以使用%routerPasswd%进入页面可以进行拨号等等相关设置，本脚本已经完成使命
pause
explorer  "http://192.168.1.1/cgi-bin/luci/admin/network/scutclient"
goto _EXIT

:_FAIL
echo 电脑与路由没连通，请检查
echo 1.路由没通电
echo 2.网线松了，坏了质量不过关
echo 3.路由是坏的,或者你试试关掉这个脚本窗口，重启路由器3分钟后重新开这个脚本试试
echo 4.可能路由器密码不是%routerPasswd%，按新手教程密码专题更改路由器密码为%routerPasswd%
echo 5.改了密码还不行可能路由器的固件有问题，按新手教程刷一把固件，还不行再截图群里问。
pause
goto _EXITFAIL

:_EXIT
cd.>%~dp0setup_ipk\commands.sh
echo 提示：已经清除敏感信息
pause
echo 按任意键结束本次设置过程，窗口自动关掉，或者等能上网了再关掉也行
pause
exit

:_EXITFAIL
echo 有时候设置失败退出脚本，重启路由器3分钟后重新开这个脚本试试，还是无法执行请按新手教程里头的刷固件办法，刷下固件。
cd.>%~dp0setup_ipk\commands.sh
echo 提示：已经清除敏感信息
pause
exit