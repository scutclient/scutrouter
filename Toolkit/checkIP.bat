@echo off 
set input=%1
echo %input%|findstr "^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$">nul||goto fail 
set _input=%input:.= % 
call :check %_input% 

:check 
if "%4"=="" goto fail 
for %%i in (%1 %2 %3 %4) do ( 
if %%i gtr 255 goto fail 
) 
echo %input% 你输入的IP错误，请重新输入 
exit

:fail 
echo (error) %input% 你输入的IP错误，请重新输入 
exit