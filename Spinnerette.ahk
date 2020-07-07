#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, %A_ScriptDir%\Icons\Spinny.ico
;https://www.spinnyverse.com/comic/02-09-2010
PAG := "Spinnerette"
URL := "https://www.spinnyverse.com/comic/hostess-x-spinny-2"
CTR := 1100
URI := "https://www.spinnyverse.com/comic"
RE1 := "next"" href=""([^""]*?)""><"
RE2 := "src=""([^""]*?)"" id"
OLD := CTR
UPD := True
LOC := "D:\Comics\_Read_\Webcomics\"
global TXT := "Running...`n`n"

Gui, Spinnerette:New, +ToolWindow +Owner
Gui, Font, s9, ProFontWindows
Gui, Add, Edit, x0 y0 w600 h200 vEDT ReadOnly Center VScroll, %TXT%
Gui, Show, w600 h200, Spinnerette

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
SpinneretteGuiClose:
ExitApp

TextAdd(TEX) {
	TXT := % TXT TEX "`n"
	GuiControl,Spinnerette:,EDT ,%TXT%
	ControlSend Edit1, ^{End}, A
	return TXT
}

GrabPage(URL) {
	TMP := A_Temp "\Spinnerette.txt"
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