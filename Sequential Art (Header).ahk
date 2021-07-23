#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

PAG:="Sequential Art"
SNM:="SeqArt"
URL:="https://www.collectedcurios.com//sequentialart.php?s=1"
CUR:=1
URI:="https://www.collectedcurios.com/"
NXT:="dOne"" href=""(.*?)""><img src=""Nav_ForwardOne"
IMG:="image"" src=""([^""]*?)"" "
TTL:=-1
LOC:=A_MyDocuments "\WebComics\"

#Include WebComics.ahk


