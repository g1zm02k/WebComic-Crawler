NXT:="data-next-id=""(.*?)"">"
IMG:="data-src=""(.*?)"""
OLD:=CUR
LOC:="D:\Comics\Webcomics\"
global TXT:="Running...`n"
if FileExist(A_ScriptDir "\Icons\Tapas.ico")
  Menu Tray,Icon,% A_ScriptDir "\Icons\Tapas.ico"
Gui Tapas:New,+ToolWindow +Owner,Tapas
Gui Font,s9,ProFontWindows
Gui Add,Edit,x0 y0 w800 h400 vEDT ReadOnly VScroll,% TXT
Gui Show,w800 h400,Tapas GUI

If !FileExist(LOC PAG)
  FileCreateDir,% LOC PAG
Loop {
  HTM:=GrabPage(URL)
  RegExMatch(HTM,NXT,NX)
  RegExMatch(HTM,IMG,IM)
  if ((NX1="-1") and (CUR=OLD)) {
    TextAdd("`nUp to date.")
    break
  } else if (IM1="") {
    TextAdd("`nImage RegEx failure!`n`nQuitting...")
    break
  }
  if ((CUR>OLD) or (CUR=1)) {
    PGP:=1,PGN:=1
    TextAdd("`nDownloading from: " URL)
    Loop {
      PGP:=RegExMatch(HTM,IMG,IM,PGP)
      if (PGP>0) {
        SAV:=% LOC PAG "\" PAG " " SubStr("000" CUR, -3) "_" SubStr("0" PGN, -1) ".jpg"
        URLDownloadToFile % IM1,% SAV
        if FileExist(SAV) {
          TextAdd("Downloaded: " SubStr(SAV, InStr(SAV, "/",, -1)+1))
          WriteSelf(PAG,URL,CUR)
        } else {
          TextAdd("`nDownload failure!`n`n  URL:" URL "`n  IM1:" IM1 "`n  NX1:" NX1 "`n  SAV:" SAV "`n`nQuitting...")
          break
        }
        PGN++
        PGP++
      } else {
        break
      }
    }
  }
  if (NX1="-1") {
    TextAdd("`nDownloaded from " OLD " to " CUR ".")
    break
  } else {
    URL:=% "https://tapas.io/episode/" NX1
    CUR++
  }
}
TextAdd("`nPress <Space> to exit...")
KeyWait Space, D
TapasGuiClose:
ExitApp

TextAdd(TEX) {
  TXT:=% TXT TEX "`n"
  GuiControl,Tapas:,EDT,% TXT
  ControlSend Edit1,^{End},Tapas
  return TXT
}

GrabPage(URL) {
  TMP:=A_Temp "/" A_Now ".txt"
  URLDownloadToFile % URL,% TMP
  FileRead HTM,% TMP
  HTM:=RegExReplace(HTM,"`n","`r`n")
  FileDelete % TMP
  return HTM
}

WriteSelf(PAG,URL,CUR) {
  FileMove % PAG " (Tapas).ahk",% PAG " (Tapas).bak",1
  FileRead TMP,% PAG " (Tapas).bak"
  TMP:=% RegExReplace(TMP,"`am)^URL:=.*", "URL:=""" URL """")
  TMP:=% RegExReplace(TMP,"`am)^CUR:=.*", "CUR:=" CUR)
  SAV:=PAG " (Tapas).ahk"
  FileAppend %TMP%, %SAV%
}