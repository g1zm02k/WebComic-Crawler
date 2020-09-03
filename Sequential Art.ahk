#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
if FileExist(A_ScriptDir "\Icons\SA.ico")
	Menu, Tray, Icon, %A_ScriptDir%\Icons\SA.ico
;https://www.collectedcurios.com/sequentialart.php?s=1
PAG := "Sequential Art"
URL := "https://www.collectedcurios.com//sequentialart.php?s=1170"
CTR := 1170
URI := "https://www.collectedcurios.com/"
RE1 := "dOne"" href=""(.*?)""><img src=""Nav_ForwardOne"
RE2 := "image"" src=""([^""]*?)"" "
OLD := CTR
UPD := True
LOC := "D:\Comics\_Read_\Webcomics\"
SNM := "SeqArt"
global SNM,TXT:="Running...`n`n"

Gui, %SNM%:New, +ToolWindow +Owner
Gui, Font, s9, ProFontWindows
Gui, Add, Edit, x0 y0 w600 h200 vEDT ReadOnly Center VScroll, %TXT%
Gui, Show, w500 h200, %SNM%

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
	SAV := % LOC PAG "\" SubStr(IMG1, InStr(IMG1, "/",, -1)+1)
	if !RegExMatch(IMG1,"https://")
		IMG1 := % URI IMG1
	TextAdd("Downloading...`nFrom: " URL "`nTo: " SAV)
	URLDownloadToFile, % IMG1, % SAV
	if FileExist(SAV)
		TextAdd("Downloaded: " SubStr(SAV, InStr(SAV, "/",, -1)+1) "`n")
	else
	{
		TextAdd("`nDownload failure!`n! " URL " !`n! " SAV " !`nQuitting...")
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
%SNM%GuiClose:
ExitApp

TextAdd(TEX) {
	TXT := % TXT TEX "`n"
	GuiControl %SNM%:,EDT ,%TXT%
	ControlSend Edit1, ^{End}, %SNM%
	return TXT
}

GrabPage(URL) {
	TMP := A_Temp "\" SNM ".txt"
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