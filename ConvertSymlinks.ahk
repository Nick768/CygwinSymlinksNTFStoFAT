#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

gosub, hexCreator

magic := "0x21 0x3c 0x73 0x79 0x6d 0x6c 0x69 0x6e 0x6b 0x3e 0xff 0xfe"
MsgBox,, Info, Now we will start to search "%A_ScriptDir%" and all subfolders..., 5

NoDescCount = 0
NoSuccessCount = 0
Loop, Files, *.lnk, R
{
	FileGetShortcut, %A_LoopFileLongPath%,,,, desc
	if (not desc = "")
	{
		filename := RTrim(StrReplace(A_LoopFileLongPath, "." . A_LoopFileExt , ""), " ")
		f := FileOpen(filename, "w")
		gosub, writeMagicToFile
		gosub, writePathToFile
		f.Close()
		FileSetAttrib, +AS, %filename%
		if (FileExist(filename))
		{
			FileDelete, %A_LoopFileLongPath%
		}
		else
		{
			NoSuccessCount++
			NoSuccess%NoSuccessCount% := A_LoopFileLongPath
		}
	}
	else
	{
		NoDescCount++
		NoDesc%NoDescCount% := A_LoopFileLongPath
	}
}

gosub, showMessages

return

writeMagicToFile:
	magicBits := StrSplit(magic, " ")
	for _, bit in magicBits
	{
		bit := Trim(bit, " `n`r`t")
		f.WriteChar(bit)
	}
	return

writePathToFile:
	fileChars := StrSplit(desc)
	for _, l in fileChars
	{
		f.Write(l)
		f.WriteChar(0x00)
	}
	f.WriteChar(0x00)
	f.WriteChar(0x00)
	return
	
showMessages:
	if (NoSuccessCount == 0 and NoDescCount == 0)
	{
		MsgBox,, SUCCESS, Everything seems to be alright `;-)
	}
	else
	{
		out := "Not successfully created:`n"
		i = 1
		while i <= NoSuccessCount
		{
			out := out . NoSuccess%i% . "`n"
			i++
		}
		out := out . "`nNo sourcepath given in following .lnk's:`n"
		i = 1
		while i <= NoDescCount
		{
			out := out . NoDesc%i% . "`n"
			i++
		}
		MsgBox,, ERROR, %out%
	}

hexCreator:
	i = 0
	while i <= 255
	{
		j = %i%
		SetFormat, IntegerFast, hex
		j += 0
		j .= ""
		SetFormat, IntegerFast, d
		if (j < 16)
		{
			j := StrReplace(j, "0x", "0x0") 
		}
		VarSetCapacity(%j%, 1)
		NumPut(i, %j%)
		i++
	}
	return