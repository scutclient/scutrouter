:On Error Resume Next 
Sub bat 
echo off & cls 
start wscript -e:vbs "%~f0" 
Exit Sub 
End Sub 

Set UAC = CreateObject("Shell.Application")
UAC.ShellExecute ".\Toolkit\RunMe.bat","","", "runas", 1