Set UAC = CreateObject("Shell.Application")
UAC.ShellExecute Wscript.Arguments(0),"","", "runas", 1