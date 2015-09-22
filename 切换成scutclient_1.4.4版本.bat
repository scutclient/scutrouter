@echo off
mshta vbscript:CreateObject("Shell.Application").ShellExecute("""%~dp0Toolkit\Switch.bat""","",,"runas",1)(window.close)&&exit /b