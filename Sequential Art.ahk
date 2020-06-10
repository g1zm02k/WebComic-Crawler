#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, %A_ScriptDir%\Icons\SA.ico
;https://www.collectedcurios.com/sequentialart.php?s=1
PAG := "Sequential Art"
URL := "https://www.collectedcurios.com/sequentialart.php?s=1161"
CTR := 1161
RE1 := "dOne"" href=""(.*?)""><img src=""Nav_ForwardOne"
RE2 := "image"" src=""([^""]*?)"" "
OLD := CTR
global TXT := "Running...`n`n"

Gui, Font, s9, ProFontWindows
Gui, Add, Edit, x0 y0 w300 h200 vEDT ReadOnly Center VScroll, %TXT%
Gui, Show, w300 h200, Seq-Art GUI

If  !FileExist("D:\Comics\_Read_\Webcomics\" PAG)
	FileCreateDir, % "D:\Comics\_Read_\Webcomics\" PAG

Loop
{
	HTM := GrabPage(URL)
	RegExMatch(HTM, RE1, NXT)
	RegExMatch(HTM, RE2, IMG)
	SAV := % "D:\Comics\_Read_\Webcomics\" PAG "\" SubStr(IMG1, InStr(IMG1, "/",, -1)+1)
	if StrLen(NXT1) = 0
	{
		if OLD = %CTR%
		{
			TextAdd("Already up to date.")
			break
		} else {
			URLDownloadToFile, % "https://www.collectedcurios.com/" IMG1, %SAV%
			If  !FileExist(SAV)
				TextAdd("Failed: " SubStr(SAV, InStr(SAV, "\",, -1)+1))
			else
				TextAdd("Downloaded: " SubStr(SAV, InStr(SAV, "\",, -1)+1))
			TextAdd("`nDownloaded up to " CTR ".")
			WriteSelf(PAG, URL, CTR)
			break
		}
	} else {
		URL := % "https://www.collectedcurios.com" NXT1
		CTR++
		URLDownloadToFile, % "https://www.collectedcurios.com/" IMG1, %SAV%
		If  !FileExist(SAV)
			TextAdd("Failed: " SubStr(SAV, InStr(SAV, "\",, -1)+1))
		else
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