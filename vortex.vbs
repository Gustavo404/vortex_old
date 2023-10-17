Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c vortex.bat"
oShell.Run strArgs, 0, false