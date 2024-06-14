# File:			 capwin_help.sh
# Purpose: 	 	 Display capwin.sh parameter options on the terminal.
# Distribution:  Part of the capwin project.
# Last updated:  06/11/2024
# Developer: 	 BiophysicsLab.com
# License: 		 The Unlicense https://unlicense.org
###############################################################################


echo ""
echo "${PURPLE}Capture Windows Utility Parameter Help${NONE}"
echo "Usage from zsh terminal app: /path/capwin.sh [<argument> ...]"

echo ""
echo "Override default values with one or more named arguments:"

echo ""
echo "\t-i <string> \tEquivalent to --imgFormat"
echo "\t   <string> \tA valid image format (file type)."
echo "\t   Default: ${CYAN}$imgFormat${NONE}"

echo ""
echo "\t-c <string> \tEquivalent to --imgCompression"
echo "\t   <string> \tA valid compression for image format used."
echo "\t   Default: ${CYAN}$imgCompression${NONE}"

echo ""
echo "\t   Tested image format and compression combinations:"
echo "\t\t Format\t Compression" 
echo "\t\t ------\t -----------"
echo -n "${CYAN}"
for ((i = 1; i <= $#imgFormatArray; i++)); do
 	echo "\t\t $imgFormatArray[i]\t $imgCompressionArray[i]"
done
echo -n "${NONE}"


echo ""
echo "\t-d <integer> \tEquivalent to --dpiImage"
echo "\t   <integer> \tDots per inch (DPI)."
echo "\t   Default: ${CYAN}$dpiImage${NONE}"

echo ""
echo "\t   Common image density values (DPI):"
echo "\t\t  DPI\t Where used" 
echo "\t\t ------\t -----------"
echo -n "${CYAN}"
echo "\t\t 72\t web"
echo "\t\t 144\t Apple's studio monitor"
echo "\t\t 300\t printer"
echo -n "${NONE}"

echo ""
echo "\t-s <boolean> \tEquivalent to --captureWithShadow"
echo "\t   <boolean> \tIncorporate shadow around window captured."
echo "\t\t\ttrue  - incorporate shadow"
echo "\t\t\tfalse - no border around image"
echo "\t   Default: ${CYAN}$captureWithShadow${NONE}"

echo ""
echo "\t-f <string> \tEquivalent to --filePath"
echo "\t   <string> \tA valid path to where image files are to be saved."
echo "\t\t\tOption 1 - Relative e.g.: ~/Desktop/"
echo "\t\t\tOption 2 - Absolute e.g.: /Users/[user]/Desktop/"
absolute2RelativePathFunc $filePath
echo "\t   Default: ${CYAN}$relativePath${NONE}"


echo ""
echo "\t-p <string> \tEquivalent to --filePuffix"
echo "\t   <string> \tDefine base image file name."
echo "\t   Default file prefix: ${CYAN}$filePrefix${NONE}"
echo "\t   Full name with unique timestamp:"\
	 "${GREEN}$filePrefix$fileSuffix.$imgFormat${NONE}"

echo ""
echo "\t-h \tEequivalent to --help"
echo "\t   Display this capture windows utility parameter help page."

echo ""
echo "Examples:"
echo "\tTest short-form command line options:"
echo -n "${CYAN}"
echo "\tcapwin.sh -i tiff -c lzw -d 72 -s true -f ~/Downloads/ -p screenshot_"
echo -n "${NONE}"
echo ""
echo "\tTest equivalent long-form command line options:"
echo -n "${CYAN}"
echo "\tcapwin.sh --imgFormat tiff --imgCompression lzw --dpiImage 72"\
	 "--captureWithShadow true --filePath ~/Downloads/"\
	 "--filePrefix screenshot_"
echo -n "${NONE}"

echo ""
echo "Additional references:"
echo "\tMan page for screenshot: https://ss64.com/mac/screencapture.html"
echo "\tMan page for sips: https://ss64.com/mac/sips.html"
echo "\tPreview guide: https://support.apple.com/en-gb/guide/preview/welcome/mac"
echo "\tDeveloper's website: BiophysicsLab.com"
echo ""
