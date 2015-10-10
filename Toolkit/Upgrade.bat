@echo off & setlocal enabledelayedexpansion
color 4A
TITLE 一键刷固件脚本  --华工路由器正式群出品
set routerPasswd=admin
pushd "%CD%"
CD /D "%~dp0"
echo ◇◇◇◇◇◇◇◇◇◇◇◇◆◇◇◇◇◇◇◆◇◇◇◇◇◇◇◇◇◇
echo ◇◇◆◆◆◆◆◆◆◇◆◇◆◇◇◇◇◇◇◆◇◇◆◆◆◆◆◇◇◇
echo ◇◇◆◇◇◇◇◇◆◇◆◇◆◇◇◇◇◇◇◆◇◇◆◇◇◇◆◇◇◇
echo ◇◇◆◇◇◇◇◆◆◇◆◇◆◇◇◇◆◆◆◆◆◆◆◇◇◇◆◇◇◇
echo ◇◇◆◆◆◆◆◆◆◇◆◇◆◇◇◇◇◇◆◆◆◇◆◇◇◇◆◇◇◇
echo ◇◇◆◇◇◆◇◇◇◇◆◇◆◇◇◇◇◇◆◆◆◇◆◇◇◇◆◇◇◇
echo ◇◇◆◆◆◆◆◆◆◇◆◇◆◇◇◇◇◆◆◆◆◆◆◇◇◇◆◇◇◇
echo ◇◇◆◆◇◆◇◇◆◇◆◇◆◇◇◇◇◆◆◆◆◆◆◇◇◇◆◇◇◇
echo ◇◇◆◆◇◆◇◇◆◇◆◇◆◇◇◇◆◆◇◆◇◆◆◇◇◇◆◇◇◇
echo ◇◆◆◆◇◆◇◇◆◇◆◇◆◇◇◇◆◆◇◆◇◆◆◇◇◇◆◇◆◆
echo ◇◆◆◆◇◆◇◇◆◇◆◇◆◇◇◇◇◇◇◆◇◆◆◇◇◇◆◇◆◆
echo ◆◆◆◆◇◆◆◆◆◇◆◇◆◇◇◇◇◇◇◆◇◆◆◇◇◇◆◇◆◆
echo ◆◆◇◇◇◆◇◇◇◇◆◆◆◇◇◇◇◇◇◆◆◆◇◇◇◇◆◆◆◆
echo ◇◇◇◇◇◆◇◇◇◇◇◇◇◇◇◇◇◇◇◆◆◆◇◇◇◇◇◇◇◇
echo.&echo =========================================================
echo 	本脚本由#华工路由器正式群#提供
echo 	注意：登陆路由器密码必须为%routerPasswd%，否则必然失败
echo.&echo =========================================================
echo.
echo 提示：先把要刷的固件（.bin格式)放进.Toolkit/upgrade_bin/文件夹
echo 提示：先把要刷的固件（.bin格式)放进.Toolkit/upgrade_bin/文件夹
echo 提示：先把要刷的固件（.bin格式)放进.Toolkit/upgrade_bin/文件夹
echo 提示：该脚本作为其他刷错固件无法使用的情况才升级固件
echo 提示：该脚本作为其他刷错固件无法使用的情况才升级固件
echo 提示：该脚本作为其他刷错固件无法使用的情况才升级固件
echo 提示：保证路由先能连通再执行脚本
echo 提示：保证路由先能连通再执行脚本
echo 提示：保证路由先能连通再执行脚本
pause
:_PING
echo.
ping -a 192.168.1.1
IF %errorlevel% EQU 0 ( goto _OK ) else ( goto _FAIL )

:_OK
echo.
echo 提示：准备传送upgrade_bin文件夹到路由的/tmp/下面
pause
echo y|pscp -scp -P 22 -pw %routerPasswd%  -r ./upgrade_bin root@192.168.1.1:/tmp/ | findstr 100% && echo OK || goto _FAIL
echo 提示：准备在路由执行升级固件
pause
echo y|plink -P 22 -pw %routerPasswd% root@192.168.1.1 "sysupgrade -n /tmp/upgrade_bin/*.bin"
echo 提示：如果看到
echo Switching to ramdisk...
echo Performing system upgrade...
echo Unlocking firmware ...
echo   
echo Writing from <stdin> to firmware ...
echo Upgrade completed
echo Rebooting system...
echo 说明升级成功了，否则失败
pause
exit
:_FAIL 
echo 提示：无法连接路由
pause
exit