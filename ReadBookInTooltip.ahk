; 读书模式
book_index:= 1
book_path:= "g:\Downloads\AutoHotkey_2.0.19\book_mode\"
book_file:= "g:\Downloads\AutoHotkey_2.0.19\book_mode\book.txt"
book:= []
book_flag:= false
reading_flag:= false
book_last_press:= A_TickCount

^XButton2:: book_mode()
book_mode()
{
	global book_flag, book, book_index, book_file, book_last_press, reading_flag
	book_flag:= !book_flag
	book_last_press:= A_TickCount
	if book_flag
	{
		Loop Files, book_path . "book*.txt", "R"
		book_file:= A_LoopFileFullPath
		if StrSplit(book_file, "\")[-1] = "book.txt"
		{
			FileMove(book_file, book_path . "book1.txt")
			book_file:= book_path . "book1.txt"
		}
		book_index:= StrSplit(StrSplit(StrSplit(book_file, "\")[-1], ".")[1], "_")[2]
		Loop Read, book_file, "UTF-8"
		{
			book.Push(A_LoopReadLine) 
		}
		;ListVars
		;Pause
		SetTimer book_check, 120 * 1000
		ToolTip("开始")
		SetTimer () => ToolTip(), -800
	}
	else
	{
		SetTimer book_check, 0
		reading_flag:= false
		FileMove(book_file, book_path . "book" . "_" . book_index . ".txt")
		ToolTip("结束")
		SetTimer () => ToolTip(), -800
	}
}
book_check() 
{
	if A_TickCount - book_last_press >= 600 * 1000
	book_mode
}
split_string(s, len:= 25)
{
	result:= ""
	Loop Parse s
	{
		result.= A_LoopField
		if (Mod(A_Index, len) = 0)
		result.= "`n"
	}
	return result
}

#HotIf book_flag
MButton::
{
	global reading_flag, book_file, book_last_press
	book_last_press:= A_TickCount
	reading_flag:= !reading_flag
	if reading_flag
	{
		try
		ToolTip(split_string(book[book_index]))
	}
	else
	{
		FileMove(book_file, book_path . "book" . "_" . book_index . ".txt")
		book_file:= book_path . "book" . "_" . book_index . ".txt"
		ToolTip()
	}
}
#HotIf

#HotIf reading_flag
WheelDown::
{
	global book_index, book_last_press
	book_last_press:= A_TickCount
	book_index:= Min(book.length, book_index + 1)
	ToolTip(book[book_index])
}
WheelUp::
{
	global book_index, book_last_press
	book_last_press:= A_TickCount
	book_index:= Max(1, book_index - 1)
	ToolTip(book[book_index])
}
#HotIf