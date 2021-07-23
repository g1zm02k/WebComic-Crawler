#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

;https://www.giantitp.com/comics/oots0001.html
PAG:="Order of the Stick"
SNM:="OOTS"
URL:="https://www.giantitp.com/comics/oots0001.html"
CUR:=1
URI:="https://www.giantitp.com/comics/"
NXT:="href=""([^""]*+)""><IMG src="".*?"" alt=""Next"
IMG:="r""><IMG src=""([^""]*+)"">"
TTL:=-1
LOC:=A_MyDocuments "\WebComics\"

#Include WebComics.ahk
