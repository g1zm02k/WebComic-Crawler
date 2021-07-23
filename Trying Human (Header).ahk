#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

;https://www.tryinghuman.com/comic/prologue--01
PAG:="Trying Human"
SNM:="TH"
URL:="https://www.tryinghuman.com/comic/prologue--01"
CUR:=1
URI:="https://www.tryinghuman.com/comic"
NXT:="rel=""next"" href=""([^""]*?)"">"
IMG:="<img title=""[^""]*?"" src=""([^""]*?)"" "
TTL:=""
LOC:=A_MyDocuments "\WebComics\"

#Include WebComics.ahk
