#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, %A_ScriptDir%\Icons\Oglaf.ico
;https://www.oglaf.com/cumsprite/
PAG := "Oglaf"
URL := "https://www.oglaf.com/hotgates/"
CTR := 774
URI := "https://www.oglaf.com"
RE1 := "href=""([^""]*?)"" rel=""next"
RE2 := "<img id=""strip"" src=""(.*?)"""
OLD := CTR
UPD := True
LOC := "D:\Comics\_Read_\Webcomics\"
global TXT := "Running...`n`n"

Gui, Oglaf:New, +ToolWindow +Owner
Gui, Font, s9, ProFontWindows
Gui, Add, Edit, x0 y0 w600 h200 vEDT ReadOnly Center VScroll, %TXT%
Gui, Show, w600 h200, Oglaf

If !FileExist(LOC PAG)
	FileCreateDir, % LOC PAG
Loop
{
	HTM := GrabPage(URL)
	RegExMatch(HTM, RE1, NXT)
	RegExMatch(HTM, RE2, IMG)
	if ((NXT1="") and (CTR=OLD))
	{
		TextAdd("Up to date.")
		UPD:=False
		break
	}
	SAV := % LOC PAG "\" SubStr("000" CTR, -3) " " SubStr(IMG1, InStr(IMG1, "/",, -1)+1)
	TextAdd("Downloading from: " URL)
	URLDownloadToFile, %IMG1%, %SAV%
	if FileExist(SAV)
		TextAdd("Downloaded: " SubStr(SAV, InStr(SAV, "/",, -1)+1) "`n")
	else
	{
		TextAdd("`nDownload failure! Quitting...")
		UPD:=False
		break
	}
	if (NXT1="")
	{
		TextAdd("Downloaded from " OLD " to " CTR ".")
		break
	} else {
		if RegExMatch(NXT1,"https://")
			URL := % NXT1
		else
			URL := % URI NXT1
		CTR++
	}
}
TextAdd("`nPress <Space> to exit...")
KeyWait, Space, D
if UPD
	WriteSelf(PAG, URL, CTR)
OglafGuiClose:
ExitApp

TextAdd(TEX) {
	TXT := % TXT TEX "`n"
	GuiControl,Oglaf:,EDT ,%TXT%
	ControlSend Edit1, ^{End}, A
	return TXT
}

GrabPage(URL) {
	TMP := A_Temp "\Oglaf.txt"
	URLDownloadToFile % URL, % TMP
	FileRead HTM, % TMP
	HTM := RegExReplace(HTM,"`n", "`r`n")
	FileDelete % TMP
	return HTM
}

WriteSelf(PAG, URL, CTR) {
	FileRead TMP, % PAG . ".ahk"
	TMP := % RegExReplace(TMP, "`am)^URL := ""[^""]*?""", "URL := """ URL """")
	TMP := % RegExReplace(TMP, "`am)^CTR := .*", "CTR := " CTR)
	SAV := PAG . ".ahk"
	FileDelete %SAV%
	FileAppend %TMP%, %SAV%
}