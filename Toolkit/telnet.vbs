on error resume next
dim WshShell
Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.run"cmd"
WScript.Sleep 200
WshShell.SendKeys"telnet 192.168.1.1"
WshShell.SendKeys"{ENTER}"
WScript.Sleep 200
WshShell.SendKeys"passwd"
WshShell.SendKeys"{ENTER}"
WScript.Sleep 200
WshShell.SendKeys"admin"
WshShell.SendKeys"{ENTER}"
WScript.Sleep 200
WshShell.SendKeys"admin"
WshShell.SendKeys"{ENTER}"
WScript.Sleep 200
WshShell.SendKeys"exit"
WshShell.SendKeys"{ENTER}"
WScript.Sleep 200
WshShell.SendKeys"exit"
WshShell.SendKeys"{ENTER}"