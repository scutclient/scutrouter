@echo off & setlocal enabledelayedexpansion
color 1A
TITLE 一键还原路由器脚本  --华工路由器正式群出品
set routerPasswd=admin
pushd "%CD%"
CD /D "%~dp0"
echo.&echo =========================================================
echo 	本脚本由#华工路由器正式群#提供
echo 	注意：登陆路由器密码必须为%routerPasswd%，否则必然失败
echo.&echo =========================================================
echo.
echo 提示：脚本将会把你连接路由的网卡设置IP，DNS为自动获得
pause
call ChangeIP.bat 2
echo 提示：已经将你连接路由的网卡设置IP，DNS为自动获得
pause
echo 提示：准备在路由执行!!!!!!还原!!!!!!脚本
echo 提示：准备在路由执行!!!!!!还原!!!!!!脚本
echo 提示：准备在路由执行!!!!!!还原!!!!!!脚本
pause
echo y|plink -P 22 -pw %routerPasswd% root@192.168.1.1 "firstboot"
echo 提示：如果没报错提示，等待路由重启完毕就执行成功了
pause
exit