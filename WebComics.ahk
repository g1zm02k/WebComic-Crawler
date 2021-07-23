If !FileExist(LOC PAG)                                     ;Ensure download location exists
  FileCreateDir % LOC PAG
If FileExist("Icons\" SNM ".ico")                          ;Set GUI icon (if exists)
  Menu Tray,Icon,% "Icons\" SNM ".ico"
If !FileExist("Logs")                                      ;Create Log folder
  FileCreateDir,% "Logs"
If !FileExist("Backups")                                   ;Create Backup folder
  FileCreateDir,% "Backups"
FileCopy % PAG ".ahk",% "Backups\" A_ScriptName,1          ;Move initial script to backups

OLD:=CUR

Global PAG,SNM,TXT:=""
Gui %SNM%:New                                              ;Create unique GUI
Gui Font,s9,Consolas
Gui Add,Text,x0 y0 w800 h188 vEDT Center,% TXT
Gui Show,w800 h188,% SNM

TextAdd("Started: " A_Hour ":" A_Min ":" A_Sec)

Loop{                                                      ;Primary loop

  HTM:=GrabPage(URL)                                       ;Grab the page itself
  If !StrLen(HTM){                                         ;Is the page empty?
    TextAdd("New page failure!`n`nURL: " URL)
    MsgBox % "Quitting..."
    ExitApp
  }

  RegExMatch(HTM,NXT,NX)                                   ;Get NEXT link
  RegExMatch(HTM,IMG,IM)                                   ;Get IMG link(s)
  If (((NX1="") || (NX1="-1")) && (CUR=OLD)){              ;If no new pages_
    TextAdd("`nUp to date.")
    Break
  }Else If (NX1="") && (IM1=""){
    TextAdd("Recursive link found...")
    MsgBox % "Quitting..."
    ExitApp
  }Else If (IM1=""){                                       ;_or images.
    TextAdd("`nImage RegEx failure!")
    MsgBox % "Quitting..."
    ExitApp
  }

  If ((CUR>OLD) || (CUR=1)){                               ;Next/First page
    If TTL && (TTL!=-1){                                   ;Get title (if req.)
      RegExMatch(HTM,TTL,TT)
      If RegExMatch(TT1,"\\|/|:|\*|\?|""|<|>|\||&#039;|&#034;|&amp;|â€™|â€œ|&rsquo;| $")
        TT1:=StripCode(TT1)                                ;Strip filename breakers
    }
    FIL:=SubStr(IM1,InStr(IM1,"/",,-1)+1)                  ;Strip any extra URL prefix
    FIL:=SubStr(FIL,1,InStr(FIL,".",,-1)-1)                ;Strip image type
    EXT:=SubStr(IM1,InStr(IM1,".",,-1)+1)                  ;Capture image type

    If !RegExMatch(EXT,"i)jpg|gif|png|webm|jpeg"){         ;Filetype error!
      TextAdd("Image filetype error: " IM1 "`n" FIL "`n" EXT)
      MsgBox % "Quitting..."
      ExitApp
    }

    SAV:=% LOC PAG "\" SubStr("000" CUR,-3) ((TTL=-1)?"":TTL?" " TT1:" " FIL) "." EXT

    If !RegExMatch(IM1,"https?://")                        ;Make sure it's a full URL
      IM1:=% URI IM1
    TextAdd("Downloading...`nFrom: " URL "`nTo: " SAV)
    URLDownloadToFile % IM1,% SAV
    If FileExist(SAV)                                      ;Check we've got the file
      TextAdd("Downloaded: " SubStr(SAV,InStr(SAV,"\",,-1)+1) "`n")
    Else{
      TextAdd("`nDownload failure!`n`n  URL: " URL "`n  IM1: " IM1 "`n  NX1: " NX1 "`n  SAV: " SAV)
      MsgBox % "Quitting..."
      ExitApp
    }
  }
  If RegExMatch(URL,NX1){                                  ;Recursive link found!
    MsgBox % "Recursive link!`n`nU: " URL "`nN: " NX1      ;TESTING LINE ONLY!
    NX1:=""                                                ;Clear it to exit normally
  }
  If (NX1=""){                                             ;No NEXT link = complete
    If (OLD!=CUR)
      TextAdd("Downloaded from " OLD " to " CUR ".")
    Else
      TextAdd("`nUp to date.")
    Break
  }Else{
    If RegExMatch(NX1,"https?://")                         ;Check for full/partial URL
      URL:=% NX1
    Else
      URL:=% URI NX1
    CUR++
  }
}
TextAdd("`nFinished: " A_Hour ":" A_Min ":" A_Sec "`n")    ;All done
WriteSelf(PAG,URL,CUR)                                     ;Update with current info
TextAdd("`nPress <Space> to exit...",0)                    ;Ready to quit...
KeyWait Space,D
%SNM%GuiClose:
  ExitApp

TextAdd(TEX,LOG:=1){                                       ;Add text to GUI with enabled logging
  TXT:=% TXT "`n" TEX
  TMP:=InStr(TXT,"`n",,0,13)
  If TMP
    TXT:=SubStr(TXT,TMP+1)
  GuiControl %SNM%:,EDT,% TXT
  If LOG
    FileAppend % TEX "`n",% "Logs\" PAG ".txt"
}

GrabPage(URL){                                             ;Download page HTML
  TMP:=A_Temp "\" SNM ".txt"
  URLDownloadToFile % URL,% TMP
  FileRead HTM,% TMP
  HTM:=RegExReplace(HTM,"`n","`r`n")
  FileDelete % TMP
  Return HTM
}

StripCode(STR){                                            ;Replace incompatible characters
  STR:=RegExReplace(STR,"\\|/|\*|""|<|>","_")
  STR:=RegExReplace(STR,":|\|","-")
  STR:=RegExReplace(STR,"\?",".")
  STR:=RegExReplace(STR,"&amp;","&")
  STR:=RegExReplace(STR,"&#039;|&#034;|&rsquo;|â€™|â€œ","'")
  STR:=RegExReplace(STR," $")
  Return STR
}

WriteSelf(PAG,URL,CUR){                                    ;Overwrite current strip with updated info
  FileRead TMP,% A_ScriptName
  FileDelete % A_ScriptName
  TMP:=% RegExReplace(TMP,"`am)^URL:=.*","URL:=""" URL """")
  TMP:=% RegExReplace(TMP,"`am)^CUR:=.*","CUR:=" CUR)
  FileAppend % TMP,% A_ScriptName
}