if (A_ScriptName="Tapas.ahk") {
  FLG:=0
  Loop {
    InputBox URL, Tapas Generator,Only enter the digits from the right part of the URL...`ne.g. If the URL is https://tapas.io/episode/255222 then`nyou only have to enter 255222`, try it!
    if ErrorLevel {
      ExitApp
    } else {
      if !RegExMatch(URL,"^[0-9]+$") {
        MsgBox Please enter digits only.
      } else {
        URL:="https://tapas.io/episode/" URL
        HTM:=GrabPage(URL)
        RegExMatch(HTM,"s-btn"">([^<]+)</a",PA)
        RegExMatch(HTM,"ber=""([0-9]+)""",CU)
        RegExMatch(HTM,"ep-title"">([^<]+)<",TT)
        if (PA1="")
          MsgBox %URL% doesn't exist, try again...
        else{
          MsgBox 3,,% "Strip: " PA1 "`nCount: " CU1 "`nTitle: " TT1 "`n`nIs this correct?"
          IfMsgBox Cancel
            ExitApp
          IfMsgBox Yes
            FLG:=1
        }
      }
    }
  } Until FLG
  PA1:=StripCode(PA1)
  PRE:=0
  Loop, Parse, PA1, " "
    PRE.=SubStr(A_LoopField,1,1)
  FileAppend,
  (
  #NoEnv
  #SingleInstance Force
  SetWorkingDir `%A_ScriptDir`%
  ;%URL%
  PAG:=%PA1%
  PRE:=%PA1%
  URL:=%URL%
  CUR:=%CU1%
  #Include Tapas.ahk
  ), % PA1 " (Tapas).ahk"
  ExitApp
}
NXT:="data-next-id=""(.*?)"">"
IMG:="data-src=""(.*?)"""
TTL:="ep-title"">([^<]+)<"
PAU:="<h1>Coming Soon!<"
OLD:=CUR
LOC:="D:\Comics\_Read_\Webcomics\"
global TXT:="Running...`n"
if FileExist(A_ScriptDir "\Icons  apas.ico")
  Menu Tray,Icon,% A_ScriptDir "\Icons  apas.ico"
Gui Tapas:New,,Tapas
Gui Font,s9,ProFontWindows
Gui Add,Edit,x0 y0 w800 h400 vEDT ReadOnly VScroll,% TXT
Gui Show,w800 h400,Tapas

If !FileExist(LOC PAG)
  FileCreateDir,% LOC PAG
Loop {
  HTM:=GrabPage(URL)
  RegExMatch(HTM,NXT,NX)
  RegExMatch(HTM,IMG,IM)
  if (((NX1="") or (NX1="-1")) and (CUR=OLD)) {
    TextAdd("`nUp to date.")
    break
  } else if RegExMatch(HTM,PAU) {
    TextAdd("`n" TT1 " Coming Soon!`n`nQuitting...")
    break
  } else if (IM1="") {
    TextAdd("`nImage RegEx failure!`n`nQuitting...")
    break
  }
  if ((CUR>OLD) or (CUR=1)) {
    RegExMatch(HTM,TTL,TT)
    if RegExMatch(TT1,"\\|/|:|\*|\?|""|<|>|\||&#039;|&#034;|&amp;|&rsquo;| $")
      TT1:=StripCode(TT1)
    PGP:=1,PGN:=1
    TextAdd("`nDownloading from: " URL)
    Loop {
      PGP:=RegExMatch(HTM,IMG,IM,PGP)
      if (PGP>0) {
        SAV:=% LOC PAG "\" PRE SubStr("000" CUR, -3) Chr(PGN+96) " " TT1 ".jpg"
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
    TextAdd("`nDownloaded from " OLD+1 " to " CUR ".")
    break
  } else {
    URL:=% "https://tapas.io/episode/" NX1
    CUR++
  }
}
TextAdd("`nPress <Space> to exit...")
KeyWait Space, D
TapasGuiClose:
FileDelete % PAG " (Tapas).bak"
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

StripCode(STR){
  STR:=RegExReplace(STR,"\\|/|\*|""|<|>","_")
  STR:=RegExReplace(STR,":|\|","-")
  STR:=RegExReplace(STR,"\?",".")
  STR:=RegExReplace(STR,"&amp;","&")
  STR:=RegExReplace(STR,"&#039;|&#034;|&rsquo;","'")
  STR:=RegExReplace(STR," $","")
  return STR
}

WriteSelf(PAG,URL,CUR) {
  FileMove % PAG " (Tapas).ahk",% PAG " (Tapas).bak",1
  FileRead TMP,% PAG " (Tapas).bak"
  TMP:=% RegExReplace(TMP,"`am)^URL:=.*", "URL:=""" URL """")
  TMP:=% RegExReplace(TMP,"`am)^CUR:=.*", "CUR:=" CUR)
  FileAppend % TMP, % PAG " (Tapas).ahk"
}
