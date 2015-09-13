@echo off 
:begin 
set input=%1
echo %input%|findstr "^[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]$">nul||goto fail 
echo %input% 是正确的MAC
exit 0
:fail 
echo (error) %input% 是错误的MAC
exit 1