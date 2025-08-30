#Requires AutoHotkey v2.0
G_MonitorNum := MonitorGetCount()
G_MonitorPos := []
G_MonitorFourPartPos := []
G_MonitorFourPartSize := []
G_MonitorTwoLRPartPos := []
G_MonitorTwoLRPartSize := []
G_MonitorTwoTBPartPos := []
G_MonitorTwoTBPartSize := []
G_WinRawPosAndSize := Map()
Loop G_MonitorNum
{
	MonitorGetWorkArea A_Index, &WL, &WT, &WR, &WB
	G_MonitorPos.InsertAt(A_Index, [WL, WT, WR, WB])
	G_MonitorFourPartPos.InsertAt(A_Index, [WL, WT, WL + (WR - WL)/2, WT, WL, WT + (WB - WT)/2, WL + (WR - WL)/2, WT + (WB - WT)/2])
	G_MonitorFourPartSize.InsertAt(A_Index, [(WR - WL)/2, (WB - WT)/2])
	G_MonitorTwoLRPartPos.InsertAt(A_Index, [WL, WT, WL + (WR - WL)/2, WT])
	G_MonitorTwoLRPartSize.InsertAt(A_Index, [(WR - WL)/2, (WB - WT)])
	G_MonitorTwoTBPartPos.InsertAt(A_Index, [WL, WT, WL, WT + (WB - WT)/2])
	G_MonitorTwoTBPartSize.InsertAt(A_Index, [(WR - WL), (WB - WT)/2])
}
;ListVars
;Pause

^+!q::
{
	currentMouseInMonitor := 0
	currentMouseInWinPart := 0
	
	CoordMode "Mouse", "Screen"
	MouseGetPos &xpos, &ypos ,&id, &control
	Loop G_MonitorNum
	{
		if( xpos > G_MonitorPos[A_Index][1] and xpos < G_MonitorPos[A_Index][3] and ypos > G_MonitorPos[A_Index][2] and ypos < G_MonitorPos[A_Index][4])
		{
			currentMouseInMonitor := A_Index
			break
		}
	}
	try
	{
		WinGetPos &winOutx, &winOuty, &winOutWidth, &winOutHeight, WinGetTitle(id)

		if( xpos > winOutx and xpos < (winOutx + winOutWidth/3) and ypos > winOuty and ypos < (winOuty + winOutHeight/3))
		{
			currentMouseInWinPart := 1
		}
		else if( xpos > (winOutx + (winOutWidth/3)*2) and xpos < (winOutx + winOutWidth) and ypos > winOuty and ypos < (winOuty + winOutHeight/3))
		{
			currentMouseInWinPart := 2
		}
		else if( xpos > winOutx and xpos < (winOutx + winOutWidth/3) and ypos > (winOuty + (winOutHeight/3)*2) and ypos < (winOuty + winOutHeight))
		{
			currentMouseInWinPart := 3
		}
		else if( xpos > (winOutx + (winOutWidth/3)*2) and xpos < (winOutx + winOutWidth) and ypos > (winOuty + (winOutHeight/3)*2) and ypos < (winOuty + winOutHeight))
		{
			currentMouseInWinPart := 4
		}
		else if( xpos > winOutx and xpos < (winOutx + winOutWidth/3) and ypos > (winOuty + winOutHeight/3) and ypos < (winOuty + (winOutHeight/3)*2))
		{
			currentMouseInWinPart := 5
		}
		else if( xpos > (winOutx + (winOutWidth/3)*2) and xpos < (winOutx + winOutWidth) and ypos > (winOuty + (winOutHeight/3)) and ypos < (winOuty + (winOutHeight/3)*2))
		{
			currentMouseInWinPart := 6
		}
		else if( xpos > (winOutx + (winOutWidth/3)) and xpos < (winOutx + (winOutWidth/3)*2) and ypos > winOuty and ypos < (winOuty + (winOutHeight/3)))
		{
			currentMouseInWinPart := 7
		}
		else if( xpos > (winOutx + (winOutWidth/3)) and xpos < (winOutx + (winOutWidth/3)*2) and ypos > (winOuty + (winOutHeight/3)*2) and ypos < (winOuty + winOutHeight))
		{
			currentMouseInWinPart := 8
		}
		else if( xpos > (winOutx + (winOutWidth/3)) and xpos < (winOutx + (winOutWidth/3)*2) and ypos > (winOuty + (winOutHeight/3)) and ypos < (winOuty + (winOutHeight/3)*2))
		{
			currentMouseInWinPart := 9
		}
		else
		{
			currentMouseInWinPart := 0
		}
		
		if not( currentMouseInWinPart = 9 )
		{
			G_WinRawPosAndSize[id] := [winOutx, winOuty, winOutWidth, winOutHeight]
		}

		if( currentMouseInWinPart >= 1 and currentMouseInWinPart <= 4 )
		{
			WinMove G_MonitorFourPartPos[currentMouseInMonitor][((currentMouseInWinPart * 2) - 1)], G_MonitorFourPartPos[currentMouseInMonitor][(currentMouseInWinPart * 2)],G_MonitorFourPartSize[currentMouseInMonitor][1],G_MonitorFourPartSize[currentMouseInMonitor][2], WinGetTitle(id)
		}
		else if( currentMouseInWinPart >= 5 and currentMouseInWinPart <= 6 )
		{
			WinMove G_MonitorTwoLRPartPos[currentMouseInMonitor][(((currentMouseInWinPart - 4) * 2) - 1)], G_MonitorTwoLRPartPos[currentMouseInMonitor][((currentMouseInWinPart - 4) * 2)],G_MonitorTwoLRPartSize[currentMouseInMonitor][1],G_MonitorTwoLRPartSize[currentMouseInMonitor][2], WinGetTitle(id)
		}
		else if( currentMouseInWinPart >= 7 and currentMouseInWinPart <= 8 )
		{
			WinMove G_MonitorTwoTBPartPos[currentMouseInMonitor][(((currentMouseInWinPart - 6) * 2) - 1)], G_MonitorTwoTBPartPos[currentMouseInMonitor][((currentMouseInWinPart - 6) * 2)],G_MonitorTwoTBPartSize[currentMouseInMonitor][1],G_MonitorTwoTBPartSize[currentMouseInMonitor][2], WinGetTitle(id)
		}
		else if( currentMouseInWinPart = 9 )
		{
			WinMove G_WinRawPosAndSize[id][1], G_WinRawPosAndSize[id][2],G_WinRawPosAndSize[id][3],G_WinRawPosAndSize[id][4], WinGetTitle(id)
		}
	}
}
