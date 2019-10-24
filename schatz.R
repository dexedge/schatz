#############################################
# SCHATZ: Download libretto images from the #
# Schatz Collection, Library of Congress    #
#                                           #
# Author: Dexter Edge                       #
# Version: 2019-10-22                       #
#############################################

# Load required packages
if (!require(stringr)) install.packages('stringr')
library(stringr)
if (!require(svDialogs)) install.packages('svDialogs')
library(svDialogs)

start_time <- Sys.time()

######### SET UNCHANGING URL ELEMENTS #########
# Base URL
head <- "https://tile.loc.gov/image-services/iiif/service:music:musschatz:"

# Tail of URL for JPEGs at largest size = 50%
tail <- "/full/pct:50.0/0/default.jpg"


######### GET USER INPUT ##############
# Get ULR of libretto thumbnail gallery
# figaro is default

figaro <- "https://www.loc.gov/resource/musschatz.16980.0?st=gallery"

libretto <- dlg_input("Enter URL of Schatz thumbnail view: ", 
                      default = figaro)
libretto <- libretto$res
cat(libretto, "\n")

# Extract Schatz resource id and construct version
# for the download URLs

resource <- str_extract(libretto, "[0-9]{5}")
cat(resource, "\n")

resource_id <- paste(substr(resource, 1, 2), ":", substr(resource, 3, 4),
      ":", substr(resource, 5, 5), ":", resource, ":", sep="")
cat(resource_id, "\n")

# Get numbers of first and last images to download
first <- dlg_input("Enter number for first image: ", default = 1)
first <- as.integer(first$res)

last <- dlg_input("Enter number for last image: ", 
                  default = first)
last <- as.integer(last$res)


# Get folder and file-name prefix for saving files locally
folder <- dlg_dir(default = getwd(),
                  title = "Select folder for downloaded images")
folder <- folder$res

prefix <- dlg_input("Enter filename prefix for downloaded images: ", 
                      default = "image-")
prefix <- prefix$res


####### CREATE VECTOR OF IMAGE NUMBERS #######
numbers <- seq(first, last)

# Numbers are always four digits, left-padded with 0s
pages <- str_pad(numbers, 4, pad = "0")

####### DOWNLOAD IMAGE FILES ########
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

end_time <- Sys.time()
cat(end_time - start_time)

####################
# Libretto gallery URLs
#
# "Le nozze di Figaro" (Vienna 1786), 56 images
#    https://www.loc.gov/resource/musschatz.16980.0?st=gallery
#
# "Don Juan" (Frankfurt 1788), 20 images
#    https://www.loc.gov/resource/musschatz.16823.0?st=gallery
# 
# Meyerbeer, "Semiramide riconsciuta" (Bolgona 1820), 33 images
#     https://www.loc.gov/resource/musschatz.22200.0?st=gallery
#
# Gluck, "Alceste" (Vienn 1767), 38 images
#     https://www.loc.gov/resource/musschatz.18018.0?st=gallery
#
####################


