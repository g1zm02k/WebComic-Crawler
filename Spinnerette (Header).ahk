#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

;https://www.spinnyverse.com/comic/02-09-2010
PAG:="Spinnerette"
SNM:="Spinny"
URL:="https://www.spinnyverse.com/comic/02-09-2010"
CUR:=1
URI:="https://www.spinnyverse.com/comic"
NXT:="next"" href=""([^""]*?)""><"
IMG:="src=""([^""]*?)"" id"
TTL:=""
LOC:=A_MyDocuments "\WebComics\"

#Include WebComics.ahk
