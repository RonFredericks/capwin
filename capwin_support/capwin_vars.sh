# File:			 capwin_vars.sh
# Purpose: 	 	 Image/path default control variables
# Distribution:  Part of the capwin.sh project.
# Creation date: 3/30/2024
# Developer: 	 BiophysicsLab.com
# License: 		 The Unlicense https://unlicense.org
###############################################################################



###############################################################################
# Initialize default parameters controlling image capture: 
#   image format,
#	image compression,
#   image dot density (dpi),
#   file path, 
#   file prefix (base name), 
#   file suffix,
#   border shadow


# Define two arrays for use in the screencapture and sips command line tools.
# Use these same arrays to display parameter examples in the help system.
# See man sips for all options.
typeset -a imgFormatArray
typeset -a imgCompressionArray
imgFormatArray=(     jpeg   jpg    tiff tif      pdf     png     psd)
imgCompressionArray=(low    normal lzw  packbits default default default)


# Define image file format.
imgFormat=jpg


# Select image compression using findInArray along with 
#   imgFormat, imgFormatArray and imgCompressionArray parameters.
indexFound=$(findInArray $imgFormat imgFormatArray)
# The pattern <-> matches any string having only numbers
if [[ "$indexFound" = <-> ]]; then
	imgCompression=$imgCompressionArray[$indexFound]
else
	echo $indexFound
	exit 1
fi

# Alternatively, select image compression manually.
# imgCompression=normal	


# Define final image dots per inch (density) for each image captured:
#   web 72, 
#   Apple studio monitor 144,
#   printer 300
dpiImage=144


# Define filePath variable as an absolute path (without ~).
relative2AbsolutePathFunc "~/Desktop/"


# Declare image file name prefix (base name).
filePrefix="screen_"


# Initialize fileSuffix for image configuration display.
#	Currently uses timestamp.
fileSuffixUpdate


# Initialize screen capture background shadow option:
# 	false: -w  -> Window capture including image border
# 	true -w -o -> Window capture without image border
captureWithShadow=false
