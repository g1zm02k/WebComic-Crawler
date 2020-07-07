#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, %A_ScriptDir%\Icons\BN.ico
;https://bearnutscomic.com/2008/08/17/01-bear-nuts/
PAG := "Bear Nuts"
URL := "https://bearnutscomic.com/2020/07/06/741-bear-nuts/"
CTR := 754
URI := "https://bearnutscomic.com"
RE1 := "href=""([^""]*?)"" rel=""next"">Next"
RE2 := "comic""> <img src=""([^""]*?)"" alt"
OLD := CTR
UPD := True
LOC := "D:\Comics\_Read_\Webcomics\"
global TXT := "Running...`n`n"

Gui, BearNuts:New, +ToolWindow +Owner
Gui, Font, s9, ProFontWindows
Gui, Add, Edit, x0 y0 w600 h200 vEDT ReadOnly Center VScroll, %TXT%
Gui, Show, w600 h200, BearNuts

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
BearNutsGuiClose:
ExitApp

TextAdd(TEX) {
	TXT := % TXT TEX "`n"
	GuiControl,BearNuts:,EDT ,%TXT%
	ControlSend Edit1, ^{End}, A
	return TXT
}

GrabPage(URL) {
	TMP := A_Temp "\BearNuts.txt"
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