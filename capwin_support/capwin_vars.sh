# File:			 capwin_vars.sh
# Purpose: 	 	 Image capture values for screencapture and sips utilities
#				 Window tiling control values for Preview app using applescript
# Distribution:  Part of the capwin project
# Last updated:  06/12/2024
# Developer: 	 BiophysicsLab.com
# License: 		 The Unlicense https://unlicense.org
###############################################################################



###############################################################################
#
# Initialize parameters controlling screencapture and sips image capture: 
#   image format,
#	image compression,
#   image dot density (dpi),
#   file path, 
#   file prefix (base name), 
#   file suffix,
#   border shadow.

# Define a 2-d lookup table with two matching arrays.
# These matching arrays are used in the help system - capwin_help.sh.
typeset -a imgFormatArray
typeset -a imgCompressionArray
imgFormatArray=(     jpeg   jpg    tiff tif      pdf     png     psd)
imgCompressionArray=(low    normal lzw  packbits default default default)

# Define image file format.
imgFormat=jpg


# Define image compression following option 1 or option 2.

# Option 1: select image compression manually.
# imgCompression=normal

# Option 2: select known good compression values for a given image file format.
if [ -z "$imgCompression" ]; then
	# indexFound is the return value from thefindInArray function
	findInArray $imgFormat imgFormatArray

	# The pattern <-> matches any string having only numbers.
	if [[ "$indexFound" = <-> ]]; then
		imgCompression=$imgCompressionArray[$indexFound]
	else
		# Otherwise display a detailed error message returned from findInArray.
		echo $indexFound
		exit 1
	fi

fi # if [ -z "$imgCompression" ]


# Define final image dots per inch (density) for each image captured.
# Examples:
#   web 72 
#   Apple studio monitor 144
#   printer 300
dpiImage=144


filePath="~/Desktop/"
filePathTest "$filePath"
relative2AbsolutePathFunc "$filePath"


# Declare image file name prefix (base name).
filePrefix="screen_"


# Initialize fileSuffix for image configuration display.
# Currently uses timestamp.
fileSuffixUpdate


# Initialize screen capture background shadow option:
# 	false: -w  -> Window capture including image border
# 	true -w -o -> Window capture without image border
captureWithShadow=false


###############################################################################
#
# Initialize parameters controlling applescript preview window tiling: 

# Declare screen geometry for stacking preview windows.
screenWidth=1920
screenHeight=1080

# Declare offset parameters for stacking preview windows.
resetX=10
resetY=10

# Declare offset parameters for each Preview window within a diagonal set.
offsetIncrementX=40
offsetIncrementY=40

# Declare offsets for tiling Preview images into another diagonal set
resetTileX=200
resetTileY=40

# Declare test for when to reset diagonal tiling algorithm
countsPerResetMax=4
