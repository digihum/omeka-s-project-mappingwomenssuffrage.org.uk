## How to use these files

To create a working static version of the map you will need to:

1. Copy the files to the root web folder of a webserver using apache2 (these files cannot work under a subdirectory such as `something.com/map`).
2. Check that the `.htaccess` file is present to handle .html references and the static API feeds
3. Adjust two hardcoded references to the domain the site is on:
  Within `/themes/omeka-theme-mapsuff/neatline/javascripts/dist/production/neatline-public6f1.js`, find two references to `baseURL = \"//alnob.lnx.warwick.ac.uk\"` and change it to the base URL

The resulting map will be available under `/neatline/fullscreen/all`
