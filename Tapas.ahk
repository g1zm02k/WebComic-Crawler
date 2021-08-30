If (A_ScriptName="Tapas.ahk"){
  FLG:=0
  Loop{
    InputBox URL, Tapas Generator,Enter the digits from the right of the URL (after '/episode/'), try it!
    If ErrorLevel{
      ExitApp
    }Else{
      If !RegExMatch(URL,"^[0-9]+$"){
        MsgBox Please enter digits only.
      }Else{
        URL:="https://tapas.io/episode/" URL
        HTM:=GrabPage(URL)
        RegExMatch(HTM,"s-btn"">([^<]+)</a",PA)
        RegExMatch(HTM,"ber=""([0-9]+)""",CU)
        RegExMatch(HTM,"ep-title"">([^<]+)<",TT)
        If (PA1="")
          MsgBox %URL% doesn't exist, try again...
        Else{
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
PAG:="%PA1%"
PRE:="%PA1%"
URL:="%URL%"
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
LOC:="D:\Comics\Webcomics\"
Global TXT:="Running...",PAG
If FileExist(A_ScriptDir "\Icons\Tapas.ico")
  Menu Tray,Icon,% A_ScriptDir "\Icons\Tapas.ico"
Gui Tapas:New,,Tapas
Gui Font,s9,Consolas
Gui Add,Text,x0 y0 w800 h188 vEDT Center,% TXT
Gui Show,w800 h188,Tapas

If !FileExist(LOC PAG)
  FileCreateDir,% LOC PAG
Loop {
  HTM:=GrabPage(URL)
  RegExMatch(HTM,NXT,NX)
  RegExMatch(HTM,IMG,IM)
  If (((NX1="") or (NX1="-1")) and (CUR=OLD)){
    TextAdd("`nUp to date.")
    Break
  }Else If RegExMatch(HTM,PAU){
    TextAdd("`n" TT1 " Coming Soon!`n`nQuitting...")
    Break
  }Else If (IM1=""){
    TextAdd("`nImage RegEx failure!`n`nQuitting...")
    Break
  }
  If ((CUR>OLD) or (CUR=1)){
    RegExMatch(HTM,TTL,TT)
    If RegExMatch(TT1,"\\|/|:|\*|\?|""|<|>|\||&#039;|&#034;|&amp;|â€™|â€œ|&rsquo;| $")
      TT1:=StripCode(TT1)
    PGP:=1,PGN:=1
    TextAdd("`nDownloading from: " URL)
    Loop{
      PGP:=RegExMatch(HTM,IMG,IM,PGP)
      If (PGP>0){
        SAV:=% LOC PAG "\" PRE SubStr("000" CUR, -3) Chr(PGN+96) " " TT1 ".jpg"
        URLDownloadToFile % IM1,% SAV
        If FileExist(SAV)
          TextAdd("Downloaded: " SubStr(SAV, InStr(SAV, "/",, -1)+1))
        Else{
          TextAdd("`nDownload failure!`n`n  URL:" URL "`n  IM1:" IM1 "`n  NX1:" NX1 "`n  SAV:" SAV "`n`nQuitting...")
          Break
        }
        PGN++
        PGP++
      }Else
        Break
    }
  }
  If (NX1="-1"){
    TextAdd("`nDownloaded from " OLD+1 " to " CUR ".")
    Break
  }Else{
    URL:=% "https://tapas.io/episode/" NX1
    CUR++
  }
}
WriteSelf(PAG,URL,CUR)
TextAdd("`nPress <Space> to exit...")
KeyWait Space,D
TapasGuiClose:
FileDelete % PAG " (Tapas).bak"
ExitApp

TextAdd(TEX){
  TXT:=% TXT "`n" TEX
  TMP:=InStr(TXT,"`n",,0,13)
  If TMP
    TXT:=SubStr(TXT,TMP+1)
  GuiControl,Tapas:,EDT,% TXT
  If !FileExist(A_ScriptDir "\Logs")
    FileCreateDir,% A_ScriptDir "\Logs"
  FileAppend % TEX "`n",% A_ScriptDir "\Logs\" PAG ".txt"
}

GrabPage(URL){
  TMP:=A_Temp "/" A_Now ".txt"
  URLDownloadToFile % URL,% TMP
  FileRead HTM,% TMP
  HTM:=RegExReplace(HTM,"`n","`r`n")
  FileDelete % TMP
  Return HTM
}

StripCode(STR){
  STR:=RegExReplace(STR,"\\|/|\*|""|<|>","_")
  STR:=RegExReplace(STR,":|\|","-")
  STR:=RegExReplace(STR,"\?",".")
  STR:=RegExReplace(STR,"&amp;","&")
  STR:=RegExReplace(STR,"&#039;|&#034;|&rsquo;|â€™|â€œ","'") ;â€™t
  STR:=RegExReplace(STR," $","")
  Return STR
}

WriteSelf(PAG,URL,CUR){
  FileRead TMP,% PAG " (Tapas).ahk"
  FileDelete % PAG " (Tapas).ahk"
  TMP:=% RegExReplace(TMP,"`am)^URL:=.*", "URL:=""" URL """")
  TMP:=% RegExReplace(TMP,"`am)^CUR:=.*", "CUR:=" CUR)
  FileAppend % TMP, % PAG " (Tapas).ahk",UTF-8
}
