# File:			 capwin_help.sh
# Purpose: 	 	 Display capwin.sh help options on terminal.
# Distribution:  Part of the capwin.sh project.
# Creation date: 3/30/2024
# Developer: 	 BiophysicsLab.com
# License: 		 The Unlicense https://unlicense.org
###############################################################################


echo ""
echo "${PURPLE}Capture Windows Utility Parameter Help${NONE}"
echo "Usage: zsh /path/capwin.sh [<argument> ...]"

echo ""
echo "Named arguments:"

echo ""
echo "\t-i [String] \tequivalent to --imgFormat"
echo "\t   [String] A valid image format (file type)."

echo ""
echo "\t-c [String] \tequivalent to --imgCompression="
echo "\t   [String] A valid image compression for image format used."

echo ""
echo "\t   Tested image format and compression combinations:"
echo "\t\t Format\t Compression" 
echo "\t\t ------\t -----------"
for ((i = 1; i <= $#imgFormatArray; i++)); do
 	echo "\t\t $imgFormatArray[i]\t $imgCompressionArray[i]"
done


echo ""
echo "\t-d [Integer] \tequivalent to --dpiImage"
echo "\t   [Integer] Dots per inch image density."

echo ""
echo "\t   Common image density values (DPI):"
echo "\t\t  DPI\t Where used" 
echo "\t\t ------\t -----------"
echo "\t\t 72\t web"
echo "\t\t 144\t Apple's studio monitor"
echo "\t\t 300\t printer"

echo ""
echo "\t-s [Boolean] \tequivalent to --captureWithShadow"
echo "\t   [Boolean] Incorporate shadow around window captured:"
echo "\n\t   true  - incorporate shadow"
echo "\t   false - no border around image"

echo ""
echo "\t-f [String] \tequivalent to --filePath"
echo "\t   [String] A valid path to where image files are to be saved."
echo "\n\t   Option 1 - Relative to user's home folder, e.g.: ~/Desktop/"
echo "\t   Option 2 - Absolute path, e.g.: /Users/[user]/Desktop/"

echo ""
echo "\t-p [String] \tequivalent to --filePrefix)"
echo "\t   [String] That part of a file name that will be the same"
echo "\t\t    for every window image captured."

echo ""
echo "\t   filePrefix example: screen_" 

echo ""
echo "\t-h \tequivalent to --help"
echo "\t   Display this capture windows utility parameter help page."

echo ""
echo "Additional references:"
echo "\tMan page for screenshot (man screenshot)"
echo "\tMan page for sips (man sips)"
echo ""
