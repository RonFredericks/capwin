#!/bin/zsh
# File:            capwin.sh
# Title:           Capture Windows Utility 
# Purpose:         Quickly capture, and optionally display, many images.
# Dependencies:    capwin_support/capwin_help.sh (part of this package:
#                                  used to display command line options)
#                  capwin_support/capwin_vars.sh (part of this package: 
#                                  easy access to default variables)
#                  capwin_support/capwin_fcns.sh (part of this package: 
#                                  reusable functions)
#                  UNLICENSE.txt (opensource license)
#                  screencapture (flexible image capture tool:
#                                  part of macOS distribution)
#                  sips (scriptable image processing system:
#                                  part of macOS distribution)
#                  preview (image and PDF viewer with editing features:
#                                  part of macOS distribution)
#                  applescript (cascade/tile images displayed with preview:
#                                  part of macOS distribution)
# Execution environment:            
#                  Z Shell (zsh) script
# Last updated:    06/13/2024
# Platforms tested: 
#                  Apple M1 Ultra, 
#                       macOS: Sonoma 14.5, and 
#                       zsh 5.9 (x86_64-apple-darwin23.0)
#                  Apple iMac (21.5-inch, Late 2013) i5, 
#                       macOS: Sierra 10.12.6, and 
#                       zsh: 5.2
# Developer:       BiophysicsLab.com
# License:         The Unlicense https://unlicense.org
###############################################################################


###############################################################################
#
# Usage Methodology
# -----------------
#
#   Download capwin.sh and support directory capwin_support into ~/Desktop from
#       github.
#   Follow usage option 1 or 2 below for specific details.
#   Launch capwin.sh script.
#   Review image configuration, 
#       (change parameters as needed) - following usage option 1 or option 2.
#   Capture as many images as needed, 
#       (such as from streaming video or while documenting application menus).
#   List each image file captured.
#   Optionally display each captured image using Apple's Preview utility,
#       (each image will be tiled on the display in reverse order with an offset 
#        using applescript).
#
# Usage Option 1:
# ---------------
#
# Use capwin script from the terminal with support for image control arguments.
#   Preparation:
#       Copy this script (capwin.sh and capwin_support directory) to:
#           /usr/local/bin
#           Example method from terminal (Enter your login password as needed):
#               sudo cp ~/Desktop/capwin.sh /usr/local/bin
#               sudo cp -R ~/Desktop/capwin_support /usr/local/bin
#       Make this script executable from terminal.
#           chmod +x /usr/local/bin/capwin.sh
#   Execution examples:
#       Execute script with default arguments from any directory on terminal, 
#           type: capwin.sh
#       Execute script after replacing default image density and image format,
#           type: capwin.sh -d 72 -i tiff
#       For help on available control arguments, 
#           type: capwin.sh --help
#
# Usage Option 2:
# ---------------
#
# Use finder to click and launch this script with default options.
#   Preparation:
#       Copy this script (capwin.sh and capwin_support directory) to ~/Desktop
#       Note: Using the desktop is my preference for a visual experience, 
#            but any path will work.
#       Make this script executable from terminal (same as option 1).
#           chmod +x /users/ronfred/Desktop/capwin.sh
#           Note: ronfred is an example, your user name will be different.
#           Note: Don't use relative path for chmod, it may not work.
#       Make script executable from finder/desktop.
#           Right Mouse Click over capwin.sh
#           Use Get Info menu option to change default launch application.
#               Get Info -> Open with -> 
#                   Other -> All Applications -> 
#                   Utilities -> Terminal.app
#               Note: Do not click "Change All..." button,
#                     as other scripts with extension .sh would then 
#                     be affected.
#   Execution:
#       Execute script by double-clicking on capwin.sh from finder or desktop.
#       Optionally change default control parameters by editing
#           ./capwin_support/capwin_vars.sh
#
# On termination:
# ---------------
#       Script exits normally with signal: exit 0
#       Script exits with error message and signal: exit 1
###############################################################################


############################### CODE SECTION ##################################
# First variables defined
###############################################################################


# Define capwin.sh version for display to user.
VERSION='Version 1.2.1, Date: 6/13/2024, BiophysicsLab.com'

# Define string color definitions (i.e. for enhanced text display using echo).
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'



############################### CODE SECTION ##################################
# Initialization
#   Load capwin functions
#   Initialize default configuration parameters
#   Override default configuration parameters from command line interface
#   Initialize screencapture image names array
#   Display configuration parameters
###############################################################################


###############################################################################
#
# Load capwin functions.
source $(dirname $0)/capwin_support/capwin_fcns.sh


###############################################################################
#
# Initialize default configuration parameters for image capture and preview.
source $(dirname $0)/capwin_support/capwin_vars.sh


###############################################################################
#
# Override default variables from command line interface.

errorSaved=""

# Allow parameter passing from terminal app by shifting through all entries.
while [[ "$#" -gt 0 ]]; do
    # Exit case parameter analysis when error was previously found.
    if [[ ! "$errorSaved" = "" ]]; then
        break
    fi

  case $1 in
    -d|--dpiImage) dpiImage="$2"
    if [[ -z $2 || "${2:0:1}" = "-" ]]; then
        errorSaved=$1
    fi
    shift;;

    -i|--imgFormat) imgFormat="$2"
    if [[ -z $2 || "${2:0:1}" = "-" ]]; then
        errorSaved=$1
    fi
    shift;;

    -c|--imgCompression) imgCompression="$2"
    if [[ -z $2 || "${2:0:1}" = "-" ]]; then
        errorSaved=$1
    fi
    shift;;

    -f|--filePath) temp="$2"
    if [[ -z $2 || "${2:0:1}" = "-" ]]; then
        errorSaved=$1
    else
        # Note: File path will automatically be in absolute format
        filePath=$temp
        filePathTest "$filePath"
    fi
    shift;;

    -p|--filePrefix) filePrefix="$2"
    if [[ -z $2 || "${2:0:1}" = "-" ]]; then
        errorSaved=$1
    fi
    shift;;

    -s|--captureWithShadow) captureWithShadow="$2"
    if [[ -z $2 || "${2:0:1}" = "-" ]]; then
        errorSaved=$1
    fi
    shift;;

    # Display command line parameter usage, examples, and references.
    -h|--help) source $(dirname $0)/capwin_support/capwin_help.sh
    exit 0;;

    *) echo "${RED}Error: Unknown parameter passed:${NONE} $1"
       echo "Type ${CYAN}capwin.sh -h${NONE} for help and some examples"
       echo ""
    exit 1;;
  esac
  if [ ! -z $errorSaved ]; then
    echo "${RED}Error: $errorSaved command requires a second parameter. \
    ${NONE}"
    echo "Type ${CYAN}capwin.sh -h${NONE} for help and some examples"
    echo ""
    exit 1
  fi

  shift
done


###############################################################################
#
# Initialize screencapture image names array.
screenShotsSaved=()


###############################################################################
#
# Display configuration parameters.
echo ""
echo "${PURPLE}Capture Windows Utility using screencapture, sips and preview${NONE}"
echo "${PURPLE}${VERSION}${NONE}"

# Generate relativePath variable for display of file path using tilde(~).
absolute2RelativePathFunc "$filePath"

echo "Image Capture Configuration: \
    \n\tFormat: ${CYAN}$imgFormat${NONE} \
    \n\tCompression: ${CYAN}$imgCompression${NONE} \
    \n\tDPI: ${CYAN}$dpiImage${NONE} \
    \n\tFile Path: ${CYAN}$relativePath${NONE} \
    \n\tFile Prefix: ${CYAN}$filePrefix${NONE} \
    \n\tUnique Timestamp/Image: ${CYAN}$fileSuffix${NONE} \
    \n\tBorder Shadow: ${CYAN}$captureWithShadow${NONE} \
    \n\tMore configuration options: ${CYAN}type capwin.sh --help${NONE}"

echo ""
# Continue capturing images until any key EXCEPT y or Y is pressed.
read -q ans"?Press [yY] to capture an image:"
if [[ ! "$ans" =~ ^[Yy]$ ]]; then
    echo ""
    displayDone
 exit 0
fi


############################### CODE SECTION ##################################
# Main loop to capture multiple images:
#   Capture one or more images.
#   Display all captured image file names.
#   Optionally preview all captured images using a tiled display.
#   Let user know that capwin utility is done.
###############################################################################


echo ""


###############################################################################
#
# Capture one or more images.
#
# Handle jpeg and jpg image formats as a special case:
#   1) DPI setting - use png format to change dpi setting.
#      Then restore image back to jpeg or jpg format.
#   2) Image compression - use jpeg format to change compression setting.
#      Then restore image back from jpeg to jpg format.

while true; do

  # Update fileSuffix variable for unique file name with each loop  
  fileSuffixUpdate

  # Capture screen 
  if ( $captureWithShadow ); then
    # using windows selection
    screencapture -w $filePath$filePrefix$fileSuffix.$imgFormat
  else
    # using windows selection and no shadow
    screencapture -w -o $filePath$filePrefix$fileSuffix.$imgFormat
  fi
  workingFileName=$filePath$filePrefix$fileSuffix
  
  if [[ "$imgFormat" = "jpg" || "$imgFormat" = "jpeg" ]]; then

    # Convert image to png format because sips does not apply dpi settings to 
    #   jpg/JPEG images
    sips $workingFileName.$imgFormat -s format png \
        --out $workingFileName."png" &> /dev/null

    # Apply dpi settings to png temporary file
    sips $workingFileName."png"\
        -s dpiHeight $dpiImage -s dpiWidth "$dpiImage" &> /dev/null

    # Restore or rename image to JPEG format because jpg image compression 
    #   fails
    sips $workingFileName."png" -s format jpeg \
        --out $workingFileName."jpeg" &> /dev/null

    # Apply desired image compression
    sips -s format jpeg -s formatOptions $imgCompression \
        $workingFileName."jpeg"\
        --out $workingFileName."jpeg" &> /dev/null

    if [[ "$imgFormat" = "jpg" ]]; then

      # Rename image to jpg file name
      mv $workingFileName."jpeg" $workingFileName."jpg"
    fi

    # Delete png temporary file
    rm $workingFileName."png"

  else

    # Apply dpi settings to image: $dpiImage
    sips $workingFileName.$imgFormat \
        -s dpiHeight "$dpiImage" -s dpiWidth "$dpiImage" &> /dev/null

    # Apply desired image compression
    sips -s format $imgFormat -s formatOptions $imgCompression \
        $workingFileName.$imgFormat \
        --out $workingFileName.$imgFormat &> /dev/null
  fi


  # Push each image file name onto array for later display.
  screenShotsSaved+=($workingFileName.$imgFormat)
  
  
  # Continue capturing images until any key EXCEPT y or Y is pressed.
  read -q  ans"?Press [yY] to capture an image:"
  echo ""
  if [[ "$ans" =~ ^[Yy]$ ]]
  then
     
  else
     echo ""
     break
  fi
  
done


###############################################################################
#
# Display all captured image file names.

if [[ ${#screenShotsSaved} > 0 ]]; then
  echo "${CYAN}List screenshots captured:${NONE}"
  # Loop through array of screenshot names
  for screenImage in $screenShotsSaved; do
    # Convert absolute path to tilde shortcut path
    absolute2RelativePathFunc "$screenImage"
    echo "\t${CYAN}$relativePath${NONE}"
  done


###############################################################################
#
# Optionally preview all captured images using a tiled display

  # Open preview windows for each image if y or Y is pressed.
  read -q  ans"?Press [yY] to preview screenshots (in reverse order):"
  echo ""

  if [[ "$ans" =~ ^[Yy]$ ]]; then

    # Use applescript to tile images in reverse order (oldest image on top).
    if [[ ${#screenShotsSaved} > 1 ]]; then

        initialX=$resetX
        initialY=$resetY

        declare -i cntsPerReset=0
        declare -i offsetX=$initialX
        declare -i offsetY=$initialY

        # Kludge to fix applescript first call to "Systems Event" error.
        # TODO: consider using applescript repeat feature with "System Events".
        firstPreview=true

        # Loop through array of screenshot names (in reverse order).
        for ((i=${#screenShotsSaved[@]}; i>0; i--)); do
            # First image captured will be the last displayed, stacked on top.
            absolute2RelativePathFunc "${screenShotsSaved[i]}"
            echo "\t${CYAN}preview $relativePath${NONE}"
            open -a preview ${screenShotsSaved[i]}

            # Kludge to fix applescript first call to "Systems Event" error.
            if $firstPreview; then
                sleep 1
                firstPreview=false
            fi

            # Cascade/nudge each previewed image down and to left 
            #   using applescript.
            osascript \
            -e 'on run {offsetX, offsetY}' \
            -e 'tell application "System Events"' \
            -e    'tell process "Preview"' \
            -e        'set position of front window to {offsetX, offsetY}' \
            -e    'end tell' \
            -e 'end tell' \
            -e 'end run' $offsetX $offsetY

            offsetX+=$offsetIncrementX
            offsetY+=$offsetIncrementY
            cntsPerReset+=1

            # Reset row/column for another set of cascaded images
            #   after image count reaches bottom/right edge of monitor.
            if (( ($offsetX+400)>$screenWidth || \
                ($offsetY+300)>$screenHeight )); then
                initialX=$initialX+$resetTileX
                initialY=$initialY+$resetTileY

                # No more room for another row/colum set of cascaded images,
                #   so just start over from the begining.
                if (( $cntsPerReset<$countsPerResetMax )); then
                    initialX=$resetX
                    initialY=$resetY
                fi

                cntsPerReset=0
                offsetX=$initialX
                offsetY=$initialY
            fi # Restart Cascade/nudge

        done # Loop through array of screenshot names

    else
        # Only one image to preview - so applescript tiling is not needed.
        absolute2RelativePathFunc "${screenShotsSaved[1]}"
        echo "\t${CYAN}preview $relativePath${NONE}"
        open -a preview ${screenShotsSaved[1]}
    fi # Use applescript to tile images in reverse order

  fi # Preview all captured images

fi # Display all captured screen image names.

###############################################################################
#
# Let user know that capwin utility is done.

displayDone


############################# REFERENCE SECTION ###############################
#
#   Take screenshots or screen recordings on Mac
#     capwin screen capture utility alternatives
#     https://support.apple.com/en-gb/guide/mac-help/mh26782/mac
#
#   The Z Shell Manual
#     Original documentation by Paul Falstad, zsh version 5.9, 2022
#     https://zsh.sourceforge.io/Doc/Release/
#     https://zsh.sourceforge.io/Doc/Release/Expansion.html#Brace-Expansion
#
#   Preview User Guide
#     macOS Sonoma 14
#     https://support.apple.com/en-gb/guide/preview/welcome/mac
#
#   AppleScript Language Guide
#     2013 Apple Inc.
#     https://applescriptlibrary.wordpress.com/wp-content/uploads/2013/11/applescriptlanguageguide-2013.pdf
#    
#   Capture an image (screencapture) man page
#     Site developed by Simon Sheppard (Somerset, England)
#     https://ss64.com/mac/screencapture.html
#
#   Scriptable image processing system (sips) man page
#     https://ss64.com/mac/sips.html
#
#   macOS image manipulation with sips (SmittyTone Messes with Micros,2019)
#     https://blog.smittytone.net/2019/10/24/macos-image-manipulation-with-sips/
#
#   Introduction to Bash and Z Shell: Passing Arguments to a Bash/Zsh Script
#     Rowan C Nicholls, Google Scholar
#     https://rowannicholls.github.io/bash/intro/passing_arguments.html
#
#   How to pass a variable in bash (zsh) script to osascript (applescript)
#     https://apple.stackexchange.com/questions/422677/
#     https://stackoverflow.com/questions/30400322/
#
#   How do I prompt a user for confirmation in bash (or zsh) script
#     https://stackoverflow.com/questions/1885525/
#
#   How Can I Expand A Tilde ~ As Part Of A Variable? (StackExchange, 2017)
#     https://unix.stackexchange.com/questions/399407
#
#   Shell Style Guide
#     Authored, revised and maintained by many Googlers, Revision 2.02
#     https://google.github.io/styleguide/shellguide.html
#
#   Clean Code: A Handbook of Agile Software Craftsmanship 
#     Robert C. Martin (Pearson Education, Inc. 2009)
#     https://github.com/martinmurciego/good-books/tree/master -> Clean Code...
#     
#   Overview of the Unlicense
#    https://choosealicense.com/licenses/unlicense/#
###############################################################################
