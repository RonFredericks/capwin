#!/bin/zsh
# File:            capwin.sh
# Title:           Capture Windows Utility 
# Purpose:         Quickly capture many windowed images
# Dependencies:    capwin_help.sh (part of this package:
#                                  used to display command line options)
#                  capwin_vars.sh (part of this package: 
#                                  easy access to default variables)
#                  UNLICENSE.txt (opensource license)
#                  screencapture (part of macOS distribution)
#                  sips (part of macOS distribution)
# Type:            Z Shell (zsh) script
# Creation date:   4/1/24
# Platforms tested: 
#                  Apple M1 Ultra, 
#                       macOS: Sonoma 14.4, and 
#                       zsh: 5.9
#                  Apple iMac (21.5-inch, Late 2013) i5, 
#                       macOS: Sierra 10.12.6, and 
#                       zsh: 5.2
# Developer:       BiophysicsLab.com
# License:         The Unlicense https://unlicense.org


###############################################################################
# Usage Option 1:
# ---------------
#
# Use script from the terminal with support for image control arguments.
#   Preparation:
#       Copy script (capwin.sh and capwin_support directory) to /usr/local/bin
#       Make script executable from terminal.
#           chmod +x /usr/local/bin/capwin.sh
#   Execution examples:
#       Execute script with default arguments from any directory on terminal, 
#           type: capwin.sh
#       Execute script after replacing default dots-per-inch and image format,
#           type: capwin.sh -d 72 -i tiff
#       For help on available control arguments, 
#           type: capwin.sh --help
#
# Usage Option 2:
# ---------------
#
# Use finder to click and launch script with default options.
#   Preparation:
#       Copy script (capwin.sh and capwin_support directory) to ~/Desktop
#       Note: Using the desktop is my preference for a visual experience, 
#           but any path will work.
#       Make script executable from terminal.
#           chmod +x /users/ronfred/Desktop/capwin.sh
#           Notes: ronfred is an example, your user name will be different.
#                  Don't use tilde (~) as part of path for chmod, 
#                  it may not work.
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


###############################################################################
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


###############################################################################
# Function: absolute2RelativePathFunc()
#           Convert absolute file path to relative file path containing tilde ~
#           Input: File path with, or without, filename in absolute format.
#
#               Example: absolute2RelativePathFunc "/Users/ronfred/Desktop/"
#
#           Output: relativePath contains path with user's home directory 
#                   replaced by tilde (~).
#
#               Example (continued): $relativePath contains "~/Desktop/"
#
#           On Error: Error message followed by exit 1
absolute2RelativePathFunc() {
    local temp="$1"
    if [[ $# != 1 ]]; then
        echo "${RED}Error: Call to absolute2RelativePathFunc must"
        echo "\tinclude one argument (initial file path)${NONE}"
        exit 1
    elif [[ $temp[1] != "/" ]]; then
        echo "${RED}Error: Call to absolute2RelativePathFunc must"
        echo "\tinclude initial backslash /${NONE}"
        exit 1
    fi
    relativePath="~$temp[${#HOME}+1,-1]"
}


###############################################################################
# Function: relative2AbsolutePathFunc() {
#           Convert tilde (~) shortcut path name to absolute path
#           Input: A file path name with or without use of tilde (~)
#
#               Example: $1 contains "~/Desktop/"
#
#           Output: filePath contains absolute path
#
#               Example: $filePath contains "/Users/ronfred/Desktop/"
#
#           On Error: Error message followed by exit 1
relative2AbsolutePathFunc() {
    local temp="$1"
    if [[ $# != 1 ]]; then
        echo "${RED}Error: Call to relative2AbsolutePathFunc must include one argument"
        echo "\tinitial file path:${NONE} $temp"
        exit 1
    elif [[ $temp[1,2] != "~/" ]]; then
        echo "${RED}Error: Call to relative2AbsolutePathFunc must include initial ~/"
        echo "\tinitial file path:${NONE}  $temp"
        exit 1
    elif [[ $temp[-1] != "/" ]]; then
        echo "${RED}Error: Call to relative2AbsolutePathFunc must include final"
        echo "\tbackslash /"
        echo "\tinitial file path:${NONE}  $temp"
        exit 1
    elif [[ $temp[1] = "~" ]]; then
        filePath=$HOME$temp[2,-1]
    else
        # Input was in absolute format so just return it unchanged
        filePath=$temp
    fi
}


###############################################################################
# Function: fileSuffixUpdate()
#           Generate file name suffix - the unique portion of image file name.
#           Input: none
#           Output: - fileSuffix variable should change value with each  
#                       loop'ed call to screencapture
#                   - result could be a date (default), or could be loop counter
#                       with some code changes for example
#
#               Example: $fileSuffix contains $(date "+%Y%m%dT%H%M%S")
fileSuffixUpdate() {
    fileSuffix=$(date "+%Y%m%dT%H%M%S")
}


###############################################################################
# Function: filePathTest()
#           Test for valid file path.
#           Input: A file path name with or without use of tilde (~)
#
#               Example: $1 contains "~/Desktop/"
#
#           Output: n/a
#           On Error: Error message followed by exit 1
filePathTest(){
    local temp="$1"
    local startOK=false

    if [[ $# != 1 ]]; then
        echo "${RED}Error:${NONE} filePath must include one argument"
        echo "\tinitial file path: $temp"
        exit 1

    elif [[ $temp[1,2] = "~/" ]]; then
      startOK=true

    elif [[ $temp[1] = "/" ]]; then
      startOK=true
    fi
  
    if [[ $temp[-1] = "/"  && $startOK ]]; then
      if [[ ! -d $temp ]]; then
        echo "${RED}Error: file path does not exist (or can't be accessed)."
        echo "File path argument:${NONE} $temp\n"
        exit 1
      else
        return
      fi
    fi

    echo "${RED}Error: filePath argument must include:"
    echo "\t  a) initial ~/ and final "/" slash, or"
    echo "\t  b) initial / and final "/" slash."
    echo "\t  Initial file path:${NONE} $temp\n"
    exit 1
}


###############################################################################
# Function: findInArray()
#           Find an element in an array.
#           Inputs: String to find
#                   Array of strings to search
#           Output: indexFound variable contains numeric index found.
#           On Error: Index not found error message, followed by exit 1
#           Note: When called from a sourced module, error message is returned
#                 in indexFound variable, and exit 1 condition does not stop 
#                 program execution.
#                 Instead, on return from findInArray, separate successful 
#                 numeric index return value from  error message return value
#                 using a test:
# 
#                   if [[ "$indexFound" = <-> ]] 
#
#                 after call to findInArray.
#
#       Example:
#
#           indexFound=$(findInArray $imgFormat imgFormatArray)
#
#       Example when called from sourced module:
#
#           # The pattern <-> matches any string having only numbers
#           if [[ "$indexFound" = <-> ]]; then
#               imgCompression=$imgCompressionArray[$indexFound]
#           else
#               echo $indexFound
#               exit 1
#           fi
#
#       Where:
#           findInArray is this function
#           $imgFormat is a string to find
#           imgFormatArray is an array of strings
findInArray(){
    local tempy=(${(P)2[@]})
    local indexFound="0"
    for ((i = 1; i <= $#tempy; i++)); do
        if [[ "$1" = "$tempy[$i]" ]]; then
            indexFound="$i"
            break
        fi
    done
    if [[ $indexFound = "0" ]]; then
        echo "${RED}Error: bad imgFormat value in findInArray:${NONE} $imgFormat"
        echo ""
        exit 1
    fi
    echo $indexFound
}


###############################################################################
# Initialize default parameters controlling image capture.

source $(dirname $0)/capwin_support/capwin_vars.sh


###############################################################################
# Initialize window selection user interface from command line.

# Allow parameter passing from terminal app by shifting through all entries.
while [[ "$#" -gt 0 ]]
  do case $1 in
    -d|--dpiImage) dpiImage="$2"
    shift;;

    -i|--imgFormat) imgFormat="$2"
    shift;;

    -c|--imgCompression) imgCompression="$2"
    shift;;

    -f|--filePath) temp="$2"
    # Convert entries starting with ~ to absolute path
    case "$temp" in "~/"*)
      temp="${HOME}/${temp#"~/"}"
    esac
    # Verify path name entry
    filePathTest "$temp"
    filePath=$temp
    shift;;

    -p|--filePrefix) filePrefix="$2"
    shift;;

    -s|--captureWithShadow) captureWithShadow="$2"
    shift;;

    -h|--help) source $(dirname $0)/capwin_support/capwin_help.sh
    exit 0;;

    *) echo "\n${RED}Error: Unknown parameter passed:${NONE} $1"
    source $(dirname $0)/capwin_support/capwin_help.sh
    exit 1;;
  esac

  shift
done


###############################################################################
# Display configuration parameters on terminal.

echo ""
echo "${PURPLE}Capture Windows Utility using screencapture and sips${NONE}"

# Generate relativePath variable for display of file path using tilde(~).
absolute2RelativePathFunc $filePath

echo "${CYAN}Image Configuration: \
    \n\tformat: $imgFormat \
    \n\tcompression: $imgCompression \
    \n\tdpi: $dpiImage \
    \n\tfilePath: $relativePath \
    \n\tfilePrefix: $filePrefix \
    \n\tfileSuffix: $fileSuffix (value changes/image) \
    \n\tborder shadow: $captureWithShadow \
    \n\tmore configuration options: type capwin.sh --help
    ${NONE}"

# Continue capturing images until any key EXCEPT y or Y is pressed.
read -q ans"?Press [yY] key to capture an image:"
if [[ "$ans" =~ ^[Yy]$ ]]
then
 # no-op
else
 echo ""
 echo "Aborting script..."
 exit
fi


###############################################################################
# Main loop to capture multiple images

# Initialize array of screencapture image names for display at end of session.
screenShotsSaved=()

echo ""
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
  read -q  ans"?Press [yY] key to capture an image:"
  echo ""
  if [[ "$ans" =~ ^[Yy]$ ]]
  then
     
  else
     echo ""
     break
  fi
  
done


###############################################################################
# Display all captured screen image names.

if [[ ${#screenShotsSaved} > 0 ]]; then
  echo "${CYAN}List screenshots captured:${NONE}"
  # Loop through array of screenshot names
  for screenImage in $screenShotsSaved; do
    # Convert absolute path to tilde shortcut path
    absolute2RelativePathFunc $screenImage
    echo "\t${CYAN}$relativePath${NONE}"
  done
fi


###############################################################################
# References:
#
#   The Z Shell Manual
#    Original documentation by Paul Falstad, zsh version 5.9, 2022
#    https://zsh.sourceforge.io/Doc/Release/
#    https://zsh.sourceforge.io/Doc/Release/Expansion.html#Brace-Expansion
#    
#   Capture an image (screencapture) man page
#    Site developed by Simon Sheppard (Somerset, England)
#    https://ss64.com/mac/screencapture.html
#
#   Scriptable image processing system (sips) man page
#    https://ss64.com/mac/sips.html
#
#   macOS image manipulation with sips (SmittyTone Messes with Micros,2019)
#    https://blog.smittytone.net/2019/10/24/macos-image-manipulation-with-sips/
#
#   Introduction to Bash and Z Shell: Passing Arguments to a Bash/Zsh Script
#    Rowan C Nicholls, Google Scholar
#    https://rowannicholls.github.io/bash/intro/passing_arguments.html
#
#   How Can I Expand A Tilde ~ As Part Of A Variable? (StackExchange, 2017)
#    https://unix.stackexchange.com/questions/399407
#
#   Shell Style Guide
#    Authored, revised and maintained by many Googlers, Revision 2.02
#    https://google.github.io/styleguide/shellguide.html
#
#   Robert C. Martin, Clean Code: A Handbook of Agile Software Craftsmanship 
#    (Pearson Education, Inc. 2009)
#    https://github.com/martinmurciego/good-books/tree/master -> Clean Code...
#     
#   Overview of the Unlicense
#    https://choosealicense.com/licenses/unlicense/#
