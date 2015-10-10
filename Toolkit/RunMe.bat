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
IF %errorlevel% EQU 0 ( goto _OK ) else ( goto NO_OPENWRT )
pause
:NO_OPENWRT
echo 该系统可能为非OPENWRT官方系统（或者是不是用OpenWrt做主机名），不适宜继续执行脚本，如果已经确定是OpenWrt系统可以继续
pause
echo.
ping -a 192.168.1.1
IF %errorlevel% EQU 0 ( goto _OK ) else ( goto _FAIL )

:_OK
echo.
echo 提示：准备telnet路由开通SSH，把密码改为admin,如果出现FATAL ERROR: Network error: Connection refused 也不用理会
pause
type telnet.scut|plink -telnet root@192.168.1.1
echo.
echo 提示：准备传送setup_ipk文件夹到路由的/tmp/下面
pause
echo y|pscp -scp -P 22 -pw %routerPasswd%  -r ./setup_ipk root@192.168.1.1:/tmp/ | findstr 100% && echo OK || goto _FAIL
echo 提示：准备在路由执行init.scut脚本
pause
echo y|plink -P 22 -pw %routerPasswd% root@192.168.1.1 "sed -i 's/\r//g;' /tmp/setup_ipk/init.scut && chmod 755 /tmp/setup_ipk/init.scut && /tmp/setup_ipk/init.scut"
echo 提示：自动配置成功，请现在拔路由器电源然后再插上(重启路由)，等弹出的网页能访问就代表启动完成了
echo 以后换帐号，换ip,MAC等等情况都可以使用%routerPasswd%进入页面可以进行拨号等等相关设置，本脚本已经完成使命
pause
explorer  "http://192.168.1.1/cgi-bin/luci/admin/scutclient"
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
pause
echo 能上网以后，可以使用浏览器进入http://192.168.1.1，使用密码%routerPasswd%登录路由网页界面慢慢摸索，可以切换中文。
echo 按任意键结束本次设置过程，窗口自动关掉，或者等能上网了再关掉也行
pause
exit

:_EXITFAIL
echo 有时候设置失败退出脚本，重启路由器3分钟后重新开这个脚本试试，还是无法执行请按新手教程里头的刷固件办法，刷下固件。
pause
exit

:_EXITNOTFOUND
echo 生成不了init.scut脚本文件，有可能被杀毒软件杀掉，请关闭或卸载杀毒软件再来一遍，如果还不行，试试换个电脑试试。
pause
exit