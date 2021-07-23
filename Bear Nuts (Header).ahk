#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

;https://bearnutscomic.com/2008/08/17/01-bear-nuts/
PAG:="Bear Nuts"
SNM:="BN"
URL:="https://bearnutscomic.com/2008/08/17/01-bear-nuts/"
CUR:=1
URI:="https://bearnutscomic.com"
NXT:="href=""([^""]*?)"" rel=""next"">Next"
IMG:="comic""> <img src=""([^""]*?)"" alt"
TTL:=""
LOC:=A_MyDocuments "\WebComics\"

#Include WebComics.ahk
