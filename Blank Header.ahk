#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

;Initial first page link for future reference
PAG:="Full title of comic"
SNM:="Short_name"
URL:="Full site link to first page"
CUR:=1
URI:="Partial URL for links"
NXT:="RegEx for 'Next' link"
IMG:="RegEx for 'Img' link"
TTL:=[-1:No Title|"":Image Name|"Other":Specified]
LOC:="Directory to save in"

#Include WebComics.ahk
