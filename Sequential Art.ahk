#NoEnv
#SingleInstance Force
url := "https://www.collectedcurios.com/sequentialart.php?s=1150"
Loop
{
	TempFile := A_Temp "/" A_Now ".txt"
	URLDownloadToFile % url, % TempFile
	FileRead fSA, % TempFile
	fSA := RegExReplace(fSA,"`n")
	FileDelete % TempFile

	tp := RegExMatch(fSA, "<img id=""strip"" src=""(.*?)"" width", iSA)
	tp := RegExMatch(fSA, "form><a href=""(.*?)""><img src=""Nav_ForwardOne", nSA)

	fWeb := % "https://www.collectedcurios.com/" . iSA1
	fSav := % "D:\Comics\_Read_\Webcomics\Sequential Art\" . iSA1
	url := % "https://www.collectedcurios.com" . nSA1

	if StrLen(nSA1) = 0
	{
		MsgBox, Done!
		break
	} else {
		URLDownloadToFile, %fWeb%, %fSav%
	}
}