s:="https://www.gunnerkrigg.com/comics/",e:=".jpg"
Loop 2444{
	m:=SubStr("0000000" A_Index,-7)
	d:=s m e
	f:="GC " m e
	If (SubStr(m,7)="01")
		MsgBox Press Okay to continue...
	Sleep 300
	UrlDownloadToFile % d,% "D:\Comics\_Read_\Webcomics\Gunnerkrigg Court\" f
}
ExitApp