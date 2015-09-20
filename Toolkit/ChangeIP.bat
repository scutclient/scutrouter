@echo off & setlocal enabledelayedexpansion
echo     修改不成功的话，请右键以管理员运行
set /A N=0
echo.
for /f "skip=1 tokens=1,* delims= " %%a in ('wmic nic where AdapterTypeId^="0" get name^,Index') do ( if "%%b" == "" ( @echo off ) else (set /A N+=1&set _!N!INDEX=%%a&call echo.[!N!] %%b %%a) )
echo.
IF !N! EQU 1 set /A input=1&goto _DEVICE_OK
set /p input=选择你本人电脑的有线网卡
:_DEVICE_OK
set /A _index=!_%input%INDEX!

if "%1"==""  ( goto _ChangeIP ) else ( goto _ChangeIP%1 )

:_ChangeIP
set var=""

echo.
echo     [1]自定义IP    [2]自动获得IP  [3]192.168.1.X
echo.
set /p var=请选择[1/2/3]:
echo.
if %var%==1 echo 设置静态IP  & goto _ChangeIP1
if %var%==2 echo 设置自动获得IP & goto _ChangeIP2
if %var%==3 echo 设置192.168.1.X & goto _ChangeIP3
goto END
:_ChangeIP1
set /p yourAddress=填写你提供给学校的IP地址  
set /p yourMask=填写你提供给学校的子网源码
set /p yourGateway=填写你提供给学校的网关地址  
wmic nicconfig where index=%_index% call enablestatic "%yourAddress%","%yourMask%"
wmic nicconfig where index=%_index% call enablestatic(%yourAddress%)
wmic nicconfig where index=%_index% call setgateways(%yourGateway%),(1)
wmic nicconfig where index=%_index% call SetDNSServerSearchOrder(202.112.17.33,114.114.114.114)
goto END
:_ChangeIP2
wmic nicconfig where index=%_index% call enabledhcp
goto END
:_ChangeIP3
wmic nicconfig where index=%_index% call enablestatic "192.168.1.11","255.255.255.0"
wmic nicconfig where index=%_index% call setgateways(192.168.1.1),(1)
wmic nicconfig where index=%_index% call SetDNSServerSearchOrder(202.112.17.33,114.114.114.114)
:END