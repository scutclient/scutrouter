@echo off 
:begin 
set input=%1
echo %input%|findstr "^[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]$">nul||goto fail 
echo %input% 你填写的MAC地址格式错误
exit 0
:fail 
echo (error) %input% 你填写的MAC地址格式错误
exit 1