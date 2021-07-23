# WebComic-Crawler

## Independant Site Scripts
Individual scripts are no longer needed as I've finally got around to merging all my individual downloaders into a master file (WebComics.ahk) that uses headers similar to how the Tapas downloader works.

'Blank Header.ahk' gives a brief description of how to format the headers, but I've uploaded all the current ones as well as leaving the old versions.

## Header files:
No longer needed here since you can generate your own from Tapas.ahk. Once you have a generated header just run it and it'll run Tapas.ahk with its parameters and download the complete comic to date - updating itself with its current position as it goes.

## Main Script:
- Now warns if RegEx fails on initial image download.
- No longer downloads duplicate last image(s) from previous run.
- Download fails now show all current variables for fault diagnosis.
- Script updates site data after each download instead of in bulk.
- Can now generate headers when given a valid Tapas comic episode number.
Note: Repeatedly copies the headers to a backup after EVERY download in case if fluffs up (deletes it when succesful) - need to change this to a log file instead at some point to avoid disk wear!

## Generate Headers:
New comic headers can be created on-the-fly by running the main script on its own and entering any comic's episode number into the box.
The episode number can be found by visiting tapas.io, selecting a (non-premium) comic, clicking on the first page and grabbing the right-most digits in the URL.
 
https://tapas.io/episode/20288 <- These digits here only (e.g. 'Sarah's Scribbles').

Just enter the digits into the text box and confirm the details (comic name, start number, and strip title) and the script will generate a header for that comic ready to use for download. Just run that header on its own and it'll start downloading immediately.

Example episode numbers for generating headers equal to the ones in this git:
-   20288 - Sarah's Scribbles (Hiatus)
-   46051 - Maximumble
-   85390 - The Pigeon Gazette (Hiatus)
-   88152 - Undying Happiness (Hiatus)
-  116577 - Brutally Honest
-  255222 - Erma
-  362370 - Cassandra Comics
- 1353906 - The Red Muscle (Moved to paid)
- 1559785 - Fangs (Hiatus)
