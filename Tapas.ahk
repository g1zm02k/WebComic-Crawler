RE1 := "data-next-id=""(.*?)"">"
RE2 := "data-src=""(.*?)"""
OLD := CTR
UPD := True
LOC := "D:\Comics\_Read_\Webcomics\"
global TXT := "Running...`n"
;Menu, Tray, Icon, %A_ScriptDir%\Icons\Tapas.ico
Gui, Tapas:New, +ToolWindow +Owner, Tapas
Gui, Font, s9, ProFontWindows
Gui, Add, Edit, x0 y0 w600 h200 vEDT ReadOnly Center VScroll, %TXT%
Gui, Show, w600 h200, Tapas GUI

If !FileExist(LOC PAG)
	FileCreateDir, % LOC PAG
Loop
{
	HTM := GrabPage(URL)
	RegExMatch(HTM, RE1, NXT)
	RegExMatch(HTM, RE2, IMG)
	if ((NXT1="-1") and (CTR=OLD))
	{
		TextAdd("`nUp to date.")
		UPD:=False
		break
	}
	else if (IMG1="")
	{
		TextAdd("`nImage RegEx failure! Quitting...")
		UPD:=False
		break
	}
	PGP := 1, PGN := 1
	TextAdd("`nDownloading from: " URL)
	Loop
	{
		PGP := RegExMatch(HTM, RE2, IMG, PGP)
		if PGP > 0
		{
			SAV := % LOC PAG "\" PAG " " SubStr("000" CTR, -3) "_" SubStr("0" PGN, -1) ".jpg"
			URLDownloadToFile, %IMG1%, %SAV%
			if FileExist(SAV)
				TextAdd("Downloaded: " SubStr(SAV, InStr(SAV, "/",, -1)+1))
			else
			{
				TextAdd("`nDownload failure! Quitting...")
				UPD:=False
				break
			}
			PGN++
			PGP++
		} else {
			break
		}
	}
	if (NXT1="-1")
	{
		TextAdd("`nDownloaded from " OLD " to " CTR ".")
		break
	} else {
		URL := % "https://tapas.io/episode/" NXT1
		CTR++
	}
}
TextAdd("`nPress <Space> to exit...")
KeyWait, Space, D
if UPD
	WriteSelf(PAG, URL, CTR)
TapasGuiClose:
ExitApp

TextAdd(TEX) {
	TXT := % TXT TEX "`n"
	GuiControl,Tapas:,EDT ,%TXT%
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