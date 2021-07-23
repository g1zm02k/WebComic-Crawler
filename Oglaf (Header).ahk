#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

;https://www.oglaf.com/cumsprite/
PAG:="Oglaf"
SNM:="Oglaf"
URL:="https://www.oglaf.com/cumsprite/"
CUR:=1
URI:="https://www.oglaf.com"
NXT:="href=""([^""]*?)"" rel=""next"
IMG:="<img id=""strip"" src=""(.*?)"""
TTL:=""
LOC:=A_MyDocuments "\WebComics\"

#Include WebComics.ahk
