@echo off & setlocal enabledelayedexpansion

>nul 2>&1 cacls.exe "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo 请求管理员权限...
    getadmin.vbs %0 %1
	exit /B
)
:gotAdmin
pushd "%CD%"
CD /D "%~dp0"

set routerPasswd=admin

echo.&echo.
echo 本脚本由#华工路由器群#提供
echo 注意：连接默认密码为%routerPasswd%
echo.&echo.
echo 输入你的常用信息
set /p User=拨号用的用户名  
set /p Password=拨号用的密码  
set /p Key=你的WIFI密码  
:MAC_LOOP
echo.&echo.
set /A N=0
for /f "skip=1 tokens=1,* delims= " %%a in ('wmic nic where ^(adaptertype like "ethernet ___._" and netconnectionstatus^="2"^) get name^,macaddress') do ( if "%%b" == "" ( @echo off ) else (set /A N+=1&set _!N!MAC=%%a&call echo.[!N!] %%b %%a) )
set /A N+=1
echo [%N%] 不是本人电脑，我要填其他MAC，要切英文状态输入法输入（格式大写字母XX:XX:XX:XX:XX:XX)
echo.&echo.
set /p input=选择你本人电脑的有线网卡:
IF %input% EQU %N% (goto DIY_MAC) ELSE (set MACaddress=!_%input%MAC! & goto MAC_END)
:DIY_MAC
set /p MACaddress=填写你提供给学校的MAC地址  
:MAC_END
checkMAC.bat %MACaddress%|findstr error && goto MAC_LOOP || goto _MAC_OK
:_MAC_OK
set /p IPaddress=填写学校给你的IP地址  
checkIP.bat %IPaddress%|findstr error && goto _MAC_OK || goto _IP_OK
:_IP_OK
set /p Mask=填写学校给你的子网掩码（MASK）  
checkIP.bat %Mask%|findstr error && goto _IP_OK || goto _MASK_OK
:_MASK_OK
set /p Gateway=填写学校给你的网关地址  
checkIP.bat %Gateway%|findstr error && goto _IP_OK || goto _GATEWAY_OK
:_GATEWAY_OK
echo opkg install /tmp/setup_ipk/libpcap_1.3.0-1_ar71xx.ipk >> .\setup_ipk\commands.sh
echo opkg install /tmp/setup_ipk/libpcap_1.3.0-1_ar71xx.ipk >> .\setup_ipk\commands.sh
echo opkg install /tmp/setup_ipk/scutclient_1.3-1_ar71xx.ipk >> .\setup_ipk\commands.sh
echo opkg install /tmp/setup_ipk/luci-app-scutclient_svn-r9961-1_ar71xx.ipk >> .\setup_ipk\commands.sh
echo uci set system.@system[0].hostname=SCUT > .\setup_ipk\commands.sh
echo uci set system.@system[0].timezone=HKT-8 >> .\setup_ipk\commands.sh
echo uci set system.@system[0].zonename='Asia/Hong Kong' >> .\setup_ipk\commands.sh
echo uci set network.wan.macaddr=%MACaddress% >> .\setup_ipk\commands.sh
echo uci set network.wan.proto=static >> .\setup_ipk\commands.sh
echo uci set network.wan.ipaddr=%IPaddress%  >> .\setup_ipk\commands.sh
echo uci set network.wan.netmask=%Mask%  >> .\setup_ipk\commands.sh
echo uci set network.wan.gateway=%Gateway% >> .\setup_ipk\commands.sh
echo uci set network.wan.dns='202.112.17.33 114.114.114.114' >> .\setup_ipk\commands.sh
echo uci set wireless.@wifi-device[0].disabled=0  >> .\setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].mode=ap  >> .\setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].ssid=QQgroup:262939451   >> .\setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].encryption=psk2  >> .\setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].key=%Key%   >> .\setup_ipk\commands.sh
echo uci set scutclient.@option[0].boot=1   >> .\setup_ipk\commands.sh
echo uci set scutclient.@option[0].enable=1   >> .\setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0]=scutclient   >> .\setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0].interface=$(uci get network.wan.interface) >> .\setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0].username=%User%   >> .\setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0].password=%Password%   >> .\setup_ipk\commands.sh
echo uci commit  >> .\setup_ipk\commands.sh
echo echo sleep 30 ^> /etc/rc.local >> .\setup_ipk\commands.sh
echo echo scutclient %User% %Password% \^& ^>^> /etc/rc.local >> .\setup_ipk\commands.sh
echo echo sleep 30 ^>^> /etc/rc.local >> .\setup_ipk\commands.sh
echo echo ntpd –n –d –p s2g.time.edu.cn ^>^> /etc/rc.local >> .\setup_ipk\commands.sh
echo echo exit 0 ^>^> /etc/rc.local >> commands.sh
echo echo 01 06 * * 1-5 killall scutclient ^> /etc/crontabs/root >> .\setup_ipk\commands.sh
echo echo 02 06 * * 1-5 scutclient %User% %Password% \^& ^>^> /etc/crontabs/root >> .\setup_ipk\commands.sh
echo echo 00 12 * * 0-7 ntpd –n –d –p s2g.time.edu.cn ^>^> /etc/crontabs/root >> .\setup_ipk\commands.sh

echo 提示：已经生成openwrt命令执行文件commands.sh
pause
echo 提示：将你连接路由的网卡设置IP为192.168.1.X
pause
call ChangeIP.bat 3
echo 提示：已经将你连接路由的网卡设置IP为192.168.1.X
pause
:_PING
ping 192.168.1.1
IF %errorlevel% EQU 0 ( goto _CONTINUE ) else ( goto _FAIL )
pause
:_CONTINUE
echo 提示：准备telnet路由开通SSH，把密码改为%routerPasswd%
pause
call telnet.vbs
echo 提示：准备传送setup_ipk文件夹到路由的/tmp/下面
pause
echo y|pscp -scp -P 22 -pw %routerPasswd%  -r ./setup_ipk root@192.168.1.1:/tmp/ | findstr 100% && echo OK || echo NO
echo 提示：准备在路由执行commands.sh脚本
pause
echo y|plink -m commands.sh -P 22 -pw %routerPasswd% root@192.168.1.1
echo 提示：自动配置成功，请拔电重启路由
pause
goto _EXIT

:_FAIL
echo 电脑与路由没连通，请检查
echo 1.路由没通电
echo 2.网线松了，坏了质量不过关
echo 3.路由是坏的
echo 等群主补充
pause
goto _EXIT

:_EXIT
echo.  > .\setup_ipk\commands.sh
call ChangeIP.bat 2
echo 提示：已经清除敏感信息，电脑ip改为自动获得
pause
exit