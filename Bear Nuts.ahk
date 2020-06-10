#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, %A_ScriptDir%\Icons\BN.ico
;https://bearnutscomic.com/2008/08/17/01-bear-nuts/
PAG := "Bear Nuts"
URL := "https://bearnutscomic.com/2020/06/08/737-bear-nuts/"
CTR := 750
RE1 := "href=""([^""]*?)"" rel=""next"">Next"
RE2 := "comic""> <img src=""([^""]*?)"" alt"
OLD := CTR
global TXT := "Running...`n`n"

Gui, Font, s9, ProFontWindows
Gui, Add, Edit, x0 y0 w300 h200 vEDT ReadOnly Center VScroll, %TXT%
Gui, Show, w300 h200, Bear Nuts GUI

If  !FileExist("D:\Comics\_Read_\Webcomics\" PAG)
	FileCreateDir, % "D:\Comics\_Read_\Webcomics\" PAG

Loop
{
	HTM := GrabPage(URL)
	RegExMatch(HTM, RE1, NXT)
	RegExMatch(HTM, RE2, IMG)
	SAV := % "D:\Comics\_Read_\Webcomics\" PAG "\" SubStr("000" CTR, -3) " " SubStr(IMG1, InStr(IMG1, "/",, -1)+1)
	if StrLen(NXT1) = 0
	{
		if OLD = %CTR%
		{
			TextAdd("Already up to date.")
			break
		} else {
			URLDownloadToFile, %IMG1%, %SAV%
			TextAdd("Downloaded: " SubStr(SAV, InStr(SAV, "\",, -1)+1))
			TextAdd("`nDownloaded up to " CTR ".")
			WriteSelf(PAG, URL, CTR)
			break
		}
	} else {
		URL := % NXT1
		CTR++
		URLDownloadToFile, %IMG1%, %SAV%
		TextAdd("Downloaded: " SubStr(SAV, InStr(SAV, "\",, -1)+1))
	}
}

WriteSelf(PAG, URL, CTR)
return

GuiClose:
ExitApp

TextAdd(TEX) {
	TXT := % TXT TEX "`n"
	GuiControl, ,EDT ,%TXT%
	ControlSend Edit1, ^{End}, A
	return TXT
}

GrabPage(URL) {
	TMP := A_Temp "/" A_Now ".txt"
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