#!/bin/zsh
# File:            zsh_apscpt_test_adv.sh
# Title:           zsh applescript test case (advanced).
# Purpose:         Capture screen images then display each of them 
#                       with an increasing offset. 
# Dependencies:    screencapture (flexible image capture tool:
#                                  part of macOS distribution)
#                  sips (scriptable image processing system:
#                                  part of macOS distribution)
#                  preview (image and PDF viewer with editing features:
#                                  part of macOS distribution)
#                  applescript (cascade/tile images displayed with preview:
#                                  part of macOS distribution)
# Execution environment:            
#                  Z Shell (zsh) script
# Creation date:   04/15/2024
# Platforms tested: 
#                  Apple M1 Ultra, 
#                       macOS: Sonoma 14.4, and 
#                       zsh: 5.9
#                  Apple iMac (21.5-inch, Late 2013) i5, 
#                       macOS: Sierra 10.12.6, and 
#                       zsh: 5.2
# Developer:       BiophysicsLab.


###############################################################################

declare -r resetX=10
declare -r resetY=10

declare -r screenWidth=1920
declare -r screenHeight=1080

initialX=$resetX
initialY=$resetY

maxImages=100

declare -i cntsPerReset=0
declare -i offsetX=$initialX
declare -i offsetY=$initialY


# Append GUID to image files to avoid clobbering a preexisting image.
testImageBase="./base_image_4968f9bb-5007-47a6-92d5-bdcd1a81e4_"

# Kludge to fix applescript first call to "Systems Event" error.
# Error message without kludge:
#   System Events got an error: Can’t get window 1 of process "Preview".
#   Invalid index. (-1719)
firstPreview=true


# Create and display some test images using screencapture and preview.
for ((i=1; i<=$maxImages; i++)); do

	# Create test image if not already available.
	if [[ ! -e $testImageBase$i.png ]]; then
		screencapture -R 100,100,50,50 $testImageBase$i.png
	fi

	# Open each test image in upper left corner of display
    open -a preview $testImageBase$i.png

    # Avoid system event error on first reference to "Preview" in applescript.
    # Note: issue can be temporarily fixed with a mac reboot.
    if $firstPreview; then
        sleep 1
        firstPreview=false
    fi

    # Cascade/nudge each previewed image down and to left using applescript.
    osascript \
    -e 'on run {offsetX, offsetY}' \
    -e 'tell application "System Events"' \
    -e    'tell process "Preview"' \
    -e        'set position of front window to {offsetX, offsetY}' \
    -e    'end tell' \
    -e 'end tell' \
    -e 'end run' $offsetX $offsetY

    offsetX+=40
    offsetY+=40
    cntsPerReset+=1

    # Restart Cascade/nudge after image count reaches bottom/right edge of monitor
    if (( ($offsetX+400)>$screenWidth || ($offsetY+300)>$screenHeight )); then
        echo "Reset x y parameters from: " $offsetX ", " $offsetY, ", " $cntsPerReset
        initialX=$initialX+200
        initialY=$initialY+40

        if (( $cntsPerReset<4 )); then
            initialX=$resetX
            initialY=$resetY
            echo "Over range reset after count: " $cntsPerReset
        fi

        cntsPerReset=0
        offsetX=$initialX
        offsetY=$initialY
        echo "Reset x y parameters to: " $offsetX ", " $offsetY
    fi

done

# References
# https://apple.stackexchange.com/questions/422677/how-to-pass-variable-in-bash-script-to-osascript
