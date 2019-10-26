# schatz
`schatz` is a script in the R programming language for downloading images of libretti from the [Schatz Collection](https://www.loc.gov/collections/albert-schatz/) at the Library of Congress. The script is intended to be usable by those with little or no experience with R or programming, and these instructions are written for that audience.

## Download R

[R](https://www.r-project.org) is a popular and widely used interactive programming language with an  emphasis on statistical and data analysis and graphical representation of the results. It is free and works on MacOS, Windows, and Linux.

Because R is an interactive language, you will need to download R and run the `schatz.R` script from the R console. However, this is not difficult to do, and the steps are straightforward.

To download R, go to [this page](https://cran.r-project.org/mirrors.html) and select a download mirror, typically a site near you. For example, if you live in the United Kingdom, you might choose the site at [Imperial College London](https://cran.ma.imperial.ac.uk). Click the link for your operating system (Linux, MacOS, or Windows) and follow the instructions there, which vary by platform. If your operating system is reasonably up-to-date, you can probably use the most recent version of R (3.6.1 as of this writing). On the Mac, you can download `R-3.6.1.pkg` (or an older version if necessary). When the file is downloaded, simply double-click on it and you'll be taken taken through the installation process.

## Download the `schatz` script

The current version of the script `schatz.R` is hosted on GitHub here:

https://github.com/dexedge/schatz

To download, click on the "Clone or download" button at the upper right and choose "Download ZIP". (Depending on what browser you're using, you may also be able to download the `schatz.R` script directly from its link on the GitHub page.) 

You may want to create a special directory (folder) on your computer for the `schatz.R` script, and this may also be a convenient place for downloading the libretto images.

## Running the `schatz` script

Start R. The R console will open. On the Mac it looks like this:

![R console on the Mac](R-console.png)

One easy way to run the `schatz` script (recommended if you're new to working with R) is to click the icon with the "R" logo (shown by the red arrow above), navigate to the directory (folder) where you've saved the script, select it, and (on the Mac) click "Open". The script will begin to run.

If you are running the script for the first time, it will download two small add-on packages that the script requires: `stringr` (which has functions  used to construct the URLs for downloading the individual images) and `svDialogs` (for user input). These should take only a few seconds to download and install, and this will happen only the first time you run the script.

The script will now take you through a short series of questions. It will first ask for the URL of the *thumbnail gallery* of the libretto you want to download. It is important to use the correct URL here, as the Schatz Collection uses different types of URLs for different things. This is easiest to show with an example.

Suppose you want to download the original 1767 Viennese libretto for Gluck's *Alceste*. When you find it in the Schatz Collection and open the main record, the URL will look like this:

https://www.loc.gov/item/2010664635/

However, this is **not** the URL that is needed for the download script. To find the URL for the download script, click on "View 38 images in sequence":

!["Alceste" main page](Alceste.png)

This will take you to the thumbnail gallery for the entire libretto. It is the URL of *this* page that the download script is expecting; for *Alceste* it is:

https://www.loc.gov/resource/musschatz.18018.0?st=gallery

The script needs the number from this URL (18018, which the script will automatically extract) to build individual URLs for downloading each image. It's best to have your URL ready and copied to the clipboard before running the `schatz` script.

Note that each box for user input in the `schatz` script comes with a default value. For the URL, it is:

https://www.loc.gov/resource/musschatz.16980.0?st=gallery

This is the libretto for the premiere production of Mozart's *Le nozze di Figaro* in Vienna in 1786. You should, of course, change this to the URL for whatever libretto you're trying to download.

The script will now ask you for the numbers of the first and last images you want to download. The default for the first image is "1", so you don't need to enter anything here if you're trying to download the complete libretto. You'll then be asked for the number of the last image you want to download; if you're downloading the complete libretto, enter its highest image number ("38" for *Alceste*). 

Note that the `schatz` script in its current form does very little error checking. If you put in a number higher than the actual last image for a particular libretto, such as `100` for *Alceste*, the script will simply halt with an error as soon as it tries to download image `39` (which doesn't exist).

The script will next open a dialogue asking you to navigate to the folder where you want to store the downloaded images, and it will then ask for the prefix you'd like to use for the image filenames, for example `alceste-`. (The default is `image-`.)

The script will now begin to download the images. It will download them at the highest available JPEG resolution, which is in fact not all that high: images that show an opening of two pages (the norm) will typically fall within the range of 100 to 200 KB. These are quite legible, and will probably be the preferred choice in most cases.

This choice is hardcoded in the `schatz` script. The other options available through the LOC interface are GIF, two lower resolutions of JPEG, JPEG2000 (not widely used), and TIFF. The GIF files seem simply to be the thumbnail images, and are unlikely to be useful. The two lower JPEG resolutions degrade the legibility of the libretto's text. The TIFF and JPEG2000 formats use a different form of URL than do the JPEG files, and would require significant modifications to the `schatz` script. If you need the uncompressed TIFF file of an individual image, this is easy enought to download "by hand" directly from the LOC site.

## Limitations

The `schatz` script will try to download the entire range of images that you've requested. Sometimes this will work without a hitch, and you'll acquire (for example) all 38 images of *Alceste* quite quickly. (The download script currently has a built-in delay of 1 second between image requests.)

However, the LOC server sometimes becomes overtaxed: the script may download, say, 10 images, and then the next request will "hang". It is R's `download.file()` function that does the work of downloading each individual file. This function has a default `timeout` option of 60 seconds; if a request by `download.file()` does not receive a response from the LOC server within 60 seconds, the script will halt with an error.

If you need to rerun the script to finish downloading a libretto, you can start with the first image that failed to download; you don't need to start over again from the beginning, as you will already have successfully downloaded the images up to the point that the request timed out. 

You can, if you wish, change the value of `timeout`: at the command prompt in the R console, simply type `options(timeout=120)` (if, for example, you want to have `download.file()` wait 120 seconds instead of 60 before giving up). You can in fact set this value to whatever you want. Provided that you choose "Don't Save" when quitting R, when R asks if you want to save your Workspace Image (it's generally recommended not to save it), `timeout` will reset to the default value of 60 seconds the next time you run the script.

However, if you're having trouble completing a download, the best strategy is often simply to try again later. Time of day seems to be important to the success of a download attempts from the LOC server. I've generally had the best luck downloading outside of regular working hours, relative to the LOC (Eastern Time in the United States), although this is only a rough rule-of-thumb. Sometimes libretti will download in the middle of a weekday without any problem.

The "Cancel" buttons on the boxes for user input unfortunately do not cancel the script, they cancel only the current input box and take you to the next one. If you cancel through all the input boxes, the script will halt with an error. At the moment, this is the only way to quit the script after it starts running. (I may add more graceful user controls as time permits.)

Please feel free to contact me with questions, bug reports, or suggestions:

dexedge at gmail dot com

