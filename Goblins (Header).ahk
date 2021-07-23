#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

;https://www.goblinscomic.com/comic/06252005/
PAG:="Goblins"
SNM:="Goblins"
URL:="https://www.goblinscomic.com/comic/06252005/"
CUR:=1
URI:="https://www.goblinscomic.com/comic"
NXT:="href=""([^""]*?)"">Next"
IMG:="src=""([^""]*?)"" id="
TTL:=""
LOC:=A_MyDocuments "\WebComics\"

#Include WebComics.ahk