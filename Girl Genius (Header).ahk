#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

;https://www.girlgeniusonline.com/comic.php?date=20021104
PAG:="Girl Genius"
SNM:="GG"
URL:="https://www.girlgeniusonline.com/comic.php?date=20021104"
CUR:=1
URI:=""
NXT:="href=""([^""]*?)"" id=""bottomnext"
IMG:="BORDER=0 SRC='([^']*?)'"
TTL:=""
LOC:=A_MyDocuments "\WebComics\"

#Include WebComics.ahk
