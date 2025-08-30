#Requires AutoHotkey v2.0
^XButton1::
{
	MouseGetPos , , &id, &control
	if( WinGetProcessName(id) = "BCompare.exe")
	{
		Send "^w"
		;ListVars
		;Pause
	}
}
