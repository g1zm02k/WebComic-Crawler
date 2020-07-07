# WebComic-Crawler
A small collection of scripts for downloading select webcomics in their entirety.

I started with Sequential Art and it does what I want so I left it as is with no UI until I get back to it.

Broodhollow was next, shortly followed by Oglaf, then the Tapas collection (which are basically all the same base script and rely on the Tapas.ahk for the legwork).

Independant Scripts:
- Bear Nuts
- Broodhollow (site no longer updated?)
- Goblins
- Oglaf
- Sequential Art
- Spinnerette
- Trying Human

All the above now have near-identical code (barring Broodhollow for obvious reasons).

The following are headers and need Tapas.ahk to run:
- Brutally Honest
- Cassandra Comics
- Mondo Mango
- Sarah's Scribbles
- Shen Comix
- The Pigeon Gazette

The next step is finding a way to have one main loop and have each comic's script as a plugin of sorts.

Anyway, they all work to some degree, and they're all self-updating and contain the index link if you want to start them from the beginning - otherwise they'll just continue from where they last left off and overwrite themselves with any updated information.
