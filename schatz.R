#############################################
# SCHATZ: Download libretto images from the #
# Schatz Collection, Library of Congress    #
#                                           #
# Author: Dexter Edge                       #
# Version: 2019-10-26                       #
#############################################

# Load required packages
if (!require(stringr)) install.packages('stringr')
library(stringr)
if (!require(svDialogs)) install.packages('svDialogs')
library(svDialogs)
if (!require(tictoc)) install.packages('tictoc')
library(tictoc)

######### SET BASE URL #########

head <- "https://tile.loc.gov/image-services/iiif/service:music:musschatz:"

######### GET USER INPUT ##############
# Get ULR of libretto thumbnail gallery
# figaro is default

figaro <- "https://www.loc.gov/resource/musschatz.16980.0?st=gallery"

libretto <- dlg_input("Enter URL of Schatz thumbnail gallery: ", 
                      default = figaro)
libretto <- libretto$res
if (length(libretto) == 0) {
  stop("Script cancelled", call. = FALSE)
}
if (libretto == '') {
  stop("Script cancelled", call. = FALSE)
}

# Extract Schatz resource id and construct version
# for the download URLs

resource <- str_extract(libretto, "[0-9]{5}")

resource_id <- paste(substr(resource, 1, 2), ":", substr(resource, 3, 4),
      ":", substr(resource, 5, 5), ":", resource, ":", sep="")

# Get numbers of first and last images to download
first <- dlg_input("Enter number for first image: ", default = 1)

first <- as.integer(first$res)
if (length(first) == 0 || is.na(first)) {
  stop("Script cancelled", call. = FALSE)
}

last <- dlg_input("Enter number for last image: ", 
                  default = first)
last <- as.integer(last$res)
if (length(last) == 0 || is.na(last)) {
  stop("Script cancelled", call. = FALSE)
}

# Get folder and file-name prefix for saving files locally
folder <- dlg_dir(default = getwd(),
                  title = "Select folder for downloaded images")
folder <- folder$res
if (length(folder) == 0) {
  stop("Script cancelled", call. = FALSE)
}

prefix <- dlg_input("Enter filename prefix for downloaded images: ", 
                      default = "image-")
prefix <- prefix$res
if (length(prefix) == 0) {
  stop("Script cancelled", call. = FALSE)
}
if (prefix == '') {
  stop("Script cancelled", call. = FALSE)
}

jpeg <- dlg_list(c(50, 75, 100), 
                 preselect = 1, title = "Select % JPEG Resolution")
jpeg <- jpeg$res

# Construct tail of URL
tail <- paste("/full/pct:", jpeg, ".0/0/default.jpg", sep="")

####### CREATE VECTOR OF IMAGE NUMBERS #######
numbers <- seq(first, last)

# Numbers are always four digits, left-padded with 0s
pages <- str_pad(numbers, 4, pad = "0")

####### DOWNLOAD IMAGE FILES ########
tic()

tryCatch(
  expr = {
    for(i in 1:(last - first + 1)) {
      url <- ""
      url <- paste(head, resource_id, pages[i], tail, sep="")
      filename <- paste(folder, prefix, pages[i], ".jpg", sep="")
      download.file(url, filename, mode="wb")
      Sys.sleep(1)
    }
  },
  error = function(e){
    message(e)
  },
  finally = {
    message("\nDone")
  }
)

toc()

#############################################################
# Gallery URLs for some libretti in the Schatz Collection
#
# "Le nozze di Figaro" (Vienna 1786), 56 images
#    https://www.loc.gov/resource/musschatz.16980.0?st=gallery
#
# "Don Juan" (Frankfurt 1788), 20 images
#    https://www.loc.gov/resource/musschatz.16823.0?st=gallery
#
# "Don Giovanni" (Prague 1787), 40 images
#    https://www.loc.gov/resource/musschatz.16901.0?st=gallery
# 
# Meyerbeer, "Semiramide riconsciuta" (Bolgona 1820), 33 images
#     https://www.loc.gov/resource/musschatz.22200.0?st=gallery
#
# Gluck, "Alceste" (Vienna 1767), 38 images
#     https://www.loc.gov/resource/musschatz.18018.0?st=gallery
#
#############################################################


