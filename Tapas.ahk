OLD := CTR
global TXT := "Running...`n`n"
Menu, Tray, Icon, %A_ScriptDir%\Icons\Tapas.ico
Gui, Font, s9, ProFontWindows
Gui, Add, Edit, x0 y0 w300 h200 vEDT ReadOnly Center VScroll, %TXT%
Gui, Show, w300 h200, %PAG% GUI

If  !FileExist("D:\Comics\_Read_\Webcomics\" PAG)
	FileCreateDir, % "D:\Comics\_Read_\Webcomics\" PAG

Loop
{
	HTM := GrabPage(URL)
	RegExMatch(HTM, "data-next-id=""(.*?)"">", RE1)
	RegExMatch(HTM, "data-src=""(.*?)""", RE2)
	if StrLen(RE11) = 2
	{
		if OLD = %CTR%
		{
			TextAdd("Already up to date.")
			break
		} else {
			GrabImg(HTM, PAG, CTR, RE2)
			TextAdd("Downloaded from " OLD " to " CTR "!")
			WriteSelf(PAG, URL, CTR)
			break
		}
	} else {
		GrabImg(HTM, PAG, CTR, RE2)
		URL := % "https://tapas.io/episode/" RE11
		CTR++
		TextAdd("Processing page " CTR "...`n")	
	}
}

WriteSelf(PAG, URL, CTR)
return

GuiClose:
ExitApp

GrabImg(HTM, PAG, CTR, RE2) {
	PGP := 1
	PGN := 1
	TextAdd("Page " CTR " downloading:")
	Loop
	{
		PGP := RegExMatch(HTM, "data-src=""(.*?)""", RE2, PGP)
		if PGP > 0
		{
			SAV := % "D:\Comics\_Read_\Webcomics\" PAG "\" PAG " " SubStr("000" CTR, -3) "_" SubStr("0" PGN, -1) ".jpg"
			URLDownloadToFile, %RE21%, %SAV%
			TextAdd("Pic " LTrim(SubStr("000" CTR, -3), "0") "/" SubStr("0" PGN, -1) " done.")
			PGN++
			PGP++
		} else {
			TextAdd("Page " LTrim(SubStr("000" CTR, -3), "0") " complete...`n")
			break
		}
	}
}

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
	SAV := PAG ".ahk"
	FileDelete %SAV%
	FileAppend #NoEnv`n#SingleInstance Force`nSetWorkingDir `%A_ScriptDir`%`n,%SAV%
	FileAppend PAG := "%PAG%"`nURL := "%URL%"`nCTR := %CTR%`n#Include Tapas.ahk,%SAV%
}