#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon,  %A_ScriptDir%\Icons\BH.ico
;https://broodhollow.chainsawsuit.com/comic/2012/10/06/book-1-curious-little-thing/
PAG := "Broodhollow"
URL := "http://broodhollow.chainsawsuit.com/comic/2019/07/22/book-3-014/"
CTR := 282
RE1 := "(?-m)rel=""next"" href=""(.*?)"""
RE2 := "(?-m)<img src=""(.*?.jpg)"""
OLD := CTR

If  !FileExist("D:\Comics\_Read_\Webcomics\" PAG)
	FileCreateDir, % "D:\Comics\_Read_\Webcomics\" PAG

Loop
{
	HTM := GrabPage(URL)
	RegExMatch(HTM, RE1, NXT)
	RegExMatch(HTM, RE2, IMG)
	SAV := % "D:\Comics\_Read_\Webcomics\" . PAG . "\" . SubStr("000" + CTR, -3) . " " . SubStr(IMG1, InStr(IMG1, "/",, -1)+1)
	if StrLen(NXT1) = 0
	{
		if OLD = %CTR%
		{
			MsgBox Nothing to download.
			break
		} else {
			URLDownloadToFile, %IMG1%, %SAV%
			MsgBox, % "Downloaded up to " . CTR . "."
			WriteSelf(PAG, URL, CTR)
			break
		}
	} else {
		URL := % NXT1
		CTR++
		URLDownloadToFile, %IMG1%, %SAV%
	}
}

WriteSelf(PAG, URL, CTR)

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
	TMP := % RegExReplace(TMP, "`am)^URL := ""[^""]*?""", "URL := """ . URL . """")
	TMP := % RegExReplace(TMP, "`am)^CTR := .*", "CTR := " . CTR)
	SAV := PAG . ".ahk"
	FileDelete %SAV%
	FileAppend %TMP%, %SAV%
}