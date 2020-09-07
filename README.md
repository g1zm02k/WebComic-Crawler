# WebComic-Crawler
A small collection of scripts for downloading select webcomics in their entirety and update themselves with their current position ready for any new comic updates.

## Independant Scripts:
- Bear Nuts
- Broodhollow (site no longer updated?)
- Goblins
- Oglaf
- Sequential Art
- Spinnerette
- Trying Human

~~The following are headers and need Tapas.inc to run:~~
- ~~Brutally Honest (Deya Muniz)~~
- ~~Cassandra Comics (Cassandra Calin)~~
- ~~Fangs (Sarah Andersen)~~
- ~~Sarah's Scribbles (Sarah Andersen)~~
- ~~The Pigeon Gazette (Pigeoneer Jane)~~
- ~~Undying Happiness (Zelkats)~~

# Massive changes!

## Header files:
No longer needed here since you can generate your own from Tapas.ahk. Once you have a generated header just run it and it'll run Tapas.ahk with its parameters and download the complete comic to date - updating itself with its current position as it goes.

## Main Script:
- Now warns if RegEx fails on initial image download.
- No longer downloads duplicate last image(s) from previous run.
- Download fails now show all current variables for fault diagnosis.
- Script updates site data after each download instead of in bulk.
- Can now generate headers when given a valid Tapas comic episode number.

## Generate Headers:
New comic headers can be created on-the-fly by running the main script on its own and entering any comic's episode number into the box.
The episode number can be found by visiting tapas.io, selecting a (non-premium) comic, clicking on the first page and grabbing the right-most digits in the URL.
 
https://tapas.io/episodes/20288 <- These digits here only (e.g. 'Sarah's Scribbles').

Just enter the digits into the text box and confirm the details (comic name, start number, and strip title) and the script will generate a header for that comic ready to use for download. Just run that header on its own and it'll start downloading immediately.

Example episode numbers for generating headers equal to the ones in this git:
-   20288 - Sarah's Scribbles
-   85390 - The Pigeon Gazette
-   88152 - Undying Happiness
-  116577 - Brutally Honest
-  255222 - Erma
-  362370 - Cassandra Comics
- 1353906 - The Red Muscle
- 1559785 - Fangs
