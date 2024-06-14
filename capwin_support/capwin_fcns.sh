# File:          capwin_fcns.sh
# Purpose:       Reusable zsh script functions
# Distribution:  Part of the capwin project
# Last updated:  06/12/2024
# Developer:     BiophysicsLab.com
# License:       The Unlicense https://unlicense.org
###############################################################################


############################ REUSABLE FUNCTIONS ###############################
# absolute2RelativePathFunc
# relative2AbsolutePathFunc
# fileSuffixUpdate
# filePathTest
# findInArray
# displayDone
###############################################################################


###############################################################################
#
# Function: absolute2RelativePathFunc()
#           Convert absolute file path (/Users.../) to 
#                   relative file path (~/.../).
#           Input: File path name in absolute format.
#                  Note: Input text string can also include the file name.
#                  Note: Input text string can also be in relative path format.
#           Output: A relative path name in global variable: relativePath
#                  Note: Output includes file name if present on input.
#           On Error: Error message followed by exit 1.
#
#               Example 1: absolute2RelativePathFunc "/Users/ronfred/Desktop/"
#                        relativePath assigned to "~/Desktop/"
#
#               Example 2: absolute2RelativePathFunc "/Users/ronfred/test/test.png"
#                        relativePath assigned to "~/test/test.png"
#
#               Example 3: absolute2RelativePathFunc "~/Desktop/"
#                        relativePath assigned to "~/Desktop/"
#
#               Example 4: absolute2RelativePathFunc "~/Desktop/test.png"
#                        relativePath assigned to "~/Desktop/test.png"
#
absolute2RelativePathFunc() {
    local inputPathNameLocal="$1"
    if [[ $# != 1 ]]; then
        echo "${RED}Error:\tCall to absolute2RelativePathFunc must" \
             "include absolute file path name${NONE}"
        echo ""
        exit 1
    fi

    if [[ $inputPathNameLocal[1,2] = "~/" ]]; then
        # File path is already in realtive format
        relativePath=$inputPathNameLocal

    else
        if [[ $inputPathNameLocal[1] != "/" ]]; then
            echo "${RED}Error:\tCall to absolute2RelativePathFunc must" \
                 "include initial backslash /"
            echo "\tInput path name:${NONE}  $inputPathNameLocal"
            echo ""
            exit 1
        fi
        relativePath="~$inputPathNameLocal[${#HOME}+1,-1]"
    fi
}


###############################################################################
#
# Function: relative2AbsolutePathFunc() {
#           Convert relative path name (~/.../) to 
#                   absolute path name (/Users.../).
#           Input: A file path name (relative or absolute).
#                  Input text string can not include the file name.
#           Output: An absolute path name in global variable: filePath
#           On Error: Error message followed by exit 1.
#
#               Example 1: relative2AbsolutePathFunc "~/Desktop/"
#                          filePath assigned to "/Users/ronfred/Desktop/"
#
#               Example 2: relative2AbsolutePathFunc "/Users/ronfred/Desktop/"
#                          filePath assigned to "/Users/ronfred/Desktop/"
#
relative2AbsolutePathFunc() {
    local inputPathNameLocal="$1"
    if [[ $# != 1 ]]; then
        echo "${RED}Error:\tCall to relative2AbsolutePathFunc must include" \
        "a file path name${NONE}"
        echo ""
        exit 1

    elif [[ $inputPathNameLocal[1,2] = "~/" ]]; then
        filePath=$HOME$inputPathNameLocal[2,-1]

    else
        # Input was in absolute format so just return it unchanged
        filePath=$inputPathNameLocal
    fi
}


###############################################################################
#
# Function: fileSuffixUpdate()
#           Generate file name suffix as a unique date/time string.
#           Input: none
#           Output: A unique timestamp string in global variable: fileSuffix.
#
#               Example: fileSuffixUpdate
#                        fileSuffix assigned to "20240425T170314"
#
fileSuffixUpdate() {
    fileSuffix=$(date "+%Y%m%dT%H%M%S")
}


###############################################################################
#
# Function: filePathTest()
#           Test for a valid directory path name.
#               Note: function returns silently when path name is valid.
#               Valid path names: 
#                   a) Initial ~/, optional file tree, and final backslash /
#                   b) Shortest valid path to home directory ~/
#                   b) Initial User folder (home directory), optional file path
#                      tree, and final backslash /
#           Input: A directory path name.
#                  Note: realtive2AbsolutePathFunc used when input 
#                        path argument starts with "~/".
#           Output: n/a
#           On Error: Error message followed by exit 1
#
#               Example 1: filePathTest "~/Desktop/"
#
#               Example 2: filePathTest "/Users/ronfred/Desktop/"
#
#               Example 3: filePathTest "/348fvn239o/"
#                          Error message includes: Directory does not exist
#
#               Example 4: filePathTest "Desktop"
#                          Error message includes: path must start with "/"
#
filePathTest(){
    local inputPathNameLocal="$1"
    local holdValueLocal
    local inputPathNameLocalAbs

    # Empty argument test should be first.  
    if [[ $# != 1 ]]; then
        echo "${RED}Error:\t Call to filePathTest must include" \
             "path name argument${NONE}"
        echo ""
        exit 1

    # capwin script assumes that file path name end with a backslash /.
    elif [[ ! $inputPathNameLocal[-1] = "/" ]]; then
        echo "${RED}Error:\t Call to filePathTest failed." 
        echo "\t Directory name must end with a final backslash /${NONE}"
        echo "${RED}\t File path tested:${NONE}" $inputPathNameLocal
        echo ""
        exit 1
    fi

    # Note: all remaining file path tests only work with absolute path names.
    #   Test 1: Path name must begin with home directory.
    #   Test 2: Path name must already exist in home directory tree.
    if [[ $inputPathNameLocal[1,2] = "~/" ]]; then
        # Convert relative path name to absolute format
        holdValueLocal=$filePath
        relative2AbsolutePathFunc "$inputPathNameLocal"
        inputPathNameLocalAbs=$filePath
        filePath=$holdValueLocal
    else
        # File path name is already in absolute format
        inputPathNameLocalAbs=$inputPathNameLocal
    fi

    # Path name must begin with home directory.
    local homeError=false
    local homeDir="$HOME/"
    if (( ${#inputPathNameLocalAbs} < ${#homeDir} )); then
        # Absolute path name must be at least as long as the home directory.
        homeError=true
    elif [[ ! "${inputPathNameLocalAbs[1,${#homeDir}]:u}" == "${homeDir:u}" ]] ;then
        # Absolute path name must begin with the home directory.
        homeError=true
    fi  
    if ( $homeError ); then
        echo "${RED}Error:\t Call to filePathTest failed."
        echo "\t Directory must start from home directory:${NONE} $homeDir"
        echo "${RED}\t File path tested:${NONE}" $inputPathNameLocalAbs
        echo ""
        exit 1
    fi

    # Path name must already exist in home directory tree.
    if [[ ! -d "${inputPathNameLocalAbs}" ]]; then
        echo "${RED}Error:\t Call to filePathTest failed."
        echo "\t Directory does not exist (or can't be accessed)."
        echo "\t File path tested:${NONE}" $inputPathNameLocal
        echo ""
        exit 1
    fi
}


###############################################################################
#
# Function: findInArray()
#           Find an element in an array.
#           Inputs: String to find 
#                       (Use a $ sign prepended to pass by value), and
#                   Array of strings to search 
#                       (Use no $ sign prepended to pass by name).
#           Output: Index found in array 
#                       (numerical position within array).
#                   An integer in global variable: indexFound.
#           On Error when called from this module: 
#                   Error message with list of valid search keys followed by
#                       program abort with exit 1.
#           On Error when called from a another sourced module:
#                   Error message is not displayed and the program's execution
#                       does not stop - wow.
#                   Instead, the indexFound variable set by findInArray is
#                       the error message!
#                   See example 2 below.
#
#       Example 1: when used in this code module:
#
#           typeset -a imgFormatArray
#           imgFormatArray=(jpeg  jpg  tiff  tif  pdf  png  psd) 
#           imgFormat=tiff
#           findInArray $imgFormat imgFormatArray
#           # indexFound set within findInArray function       
#           echo "Example 1 Index found: $indexFound"
#           # Otherwise findInArray displays error and exits program.
#
#       Example 2: when called from another sourced module (i.e. capwin_vars)
#
#           typeset -a imgFormatArray
#           imgFormatArray=(jpeg  jpg  tiff  tif  pdf  png  psd) 
#           imgFormat=tif
#           # indexFound set within findInArray function
#           findInArray $imgFormat imgFormatArray
#           # The pattern <-> matches any string having only numbers.
#           if [[ "$indexFound" = <-> ]]; then
#               # On success $indexFound is an integer pointing to an element
#               # in imgFormatArray.
#               echo "Example 2 Index found: $indexFound"
#           else
#               # Display error message passed via findInArray to $indexFound.
#               echo $indexFound
#           fi
#
#       Where:
#           findInArray is this function
#           $imgFormat is a string to find
#           imgFormatArray is an array of strings to search
#
findInArray(){
    local stringToFind=$1
    # Note: (P) parameter expansion is used below to regenerate the array 
    #   from the name of the array passed as the second argument ($2).
    local arrayToSearch=(${(P)2[@]})
    indexFound=0

    for ((i = 1; i <= $#arrayToSearch; i++)); do
        if [[ "$1" = "$arrayToSearch[$i]" ]]; then
            indexFound=$i
            break
        fi
    done

    if [ $indexFound = 0 ]; then
        echo "${RED}Error:\t Search failed in findInArray function."
        echo "\t Search key:${NONE} $stringToFind ${RED}"
        echo "\t Search array:${NONE}" 
        for ((i = 1; i <= $#arrayToSearch; i++)); do
            echo "\t\t$arrayToSearch[$i]";
        done
        echo ""
        exit 1
    fi
}


###############################################################################
#
# Function: displayDone()
#           Reuse capwin's successful done message
#           Input: n/a
#           Output: n/a
displayDone(){
    echo "${PURPLE}Capture Windows Utility done.${NONE}\n"
}

